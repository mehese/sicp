#lang sicp

(#%require "amb.scm")

;; TO DO: FIX NEGATE

(define (amb-lst lst)
  (if (null? lst)
      (amb)
      (amb (car lst)
           (amb-lst (cdr lst)))))

;; Again, Inchmeal's post was more than helpful
;;  https://www.inchmeal.io/sicp/ch-4/ex-4.78.html
;; 
;; A second solution is found here https://github.com/l0stman/sicp/blob/master/amb-query.scm
;;  (linked from the Scheme community wiki)

;; I took a slightly different approach. I didn't use the amb evaluator from section
;;  4.3 per se, but I found a Racket amb implementation that I just import here, which was
;;  supposed to keep me from passing stuff to evaluator functions, and let me use awkward
;;  primitives like display in peace. As the people with the solutions above noticed,
;;  the main issue comes when trying to write functions with negate. As requires checking the
;;  result of qeval, we can end up in a pickle as qeval can call (amb) from about 100
;;  different places and mess up my well laid plans.
;;
;; The two solutions in the links above are more elegant, as they create a new special form
;;  in the amb evaluator that checks for solutions until one fails. My approach was to avoid
;;  doing this (and maybe stick closer to the requirements of the problem by not modifying the
;;  amb evaluator). On the downside, I had to reimplement a special version of qeval that
;;  doesn't use (amb) calls, as well as duplicate versions for pretty much all the functions
;;  that can be called from qeval2 and don't use amb. This way we can check if a solution actually
;;  converges with negate and pass further the results. I am missing a qeval2 version of negate,
;;  but the code is already messy, and the only difference from the qeval negate is that the
;;  negatable negate would return a #f instead of (amb).

;; The test cases below all show similar results to those outputted by the stream-based
;;  query evaluator.

'(and (supervisor ?x ?y) (not (supervisor ?x (Bitdiddle Ben))))

'(and (supervisor ?x ?y)
      (not (or (supervisor ?x (Warbucks Oliver))
               (supervisor ?x (Bitdiddle Ben)))))

'(and (supervisor ?x ?y)
      (not (and 
                (supervisor ?x (Bitdiddle Ben))
                (job ?x (computer technician)))))

'(and (job ?x ?y)
      (salary ?x ?pay)
      (not (lisp-value > ?pay 40000)))

'{and {supervisor ?x ?y}
     {not {supervisor ?x {Warbucks Oliver}}}}

'(or {supervisor ?x  (Scrooge Eben)} {supervisor ?x (Warbucks Oliver)} )

'(and (salary ?person ?value) (lisp-value > ?value 40000))

'(married ?who Minnie)  ;; This still returns the same solutions no matter how
                        ;;  many times we try-again, but at least now it's not blocking
                        ;;  the whole interpreter

(define input-prompt ";;; Query input:")
(define output-prompt ";;; Query results:")

(define (new-problem query)
  (instantiate query
               (qeval query  '())
               (lambda (v f) (contract-question-mark v))))

(define (amb-msg q)
  (display "No more choices for ") (display q))

(define (query-driver-loop)
  (prompt-for-input input-prompt)
  (let ((q (query-syntax-process (read))))
    (cond ((eq? q 'try-again)
           (with-handlers ([exn? (lambda (exn) (display "I SAID NO MORE CHOICES LEFT!!!"))])
             (amb))
           (query-driver-loop))
          ((assertion-to-be-added? q)
           (add-rule-or-assertion! (add-assertion-body q))
           (newline)
           (display "Assertion added to data base.")
           (query-driver-loop))
          (else
           (newline)
           (display output-prompt)
           (newline)
           (with-handlers ([exn? (lambda (exn) (amb-msg q))])
             (display (new-problem q)))
           (query-driver-loop)))))

(define (instantiate exp frame unbound-var-handler)
  (define (copy exp)
    (cond ((var? exp)
           (let ((binding (binding-in-frame exp frame)))
             (if binding
                 (copy (binding-value binding))
                 (unbound-var-handler exp frame))))
          ((pair? exp)
           (cons (copy (car exp)) (copy (cdr exp))))
          (else exp)))
  (copy exp))


;;;SECTION 4.4.4.2
;;;The Evaluator

(define (qeval query frame)
  (let ((qproc (get (type query) 'qeval)))
    (if qproc
        (qproc (contents query) frame)
        (simple-query query frame))))

;;;Simple queries

(define (simple-query query-pattern frame)
  (amb (find-assertions query-pattern frame)
       (apply-rules query-pattern frame)))

;;;Compound queries

(define (conjoin conjuncts frame)
  (if (empty-conjunction? conjuncts)
      frame
      (conjoin (rest-conjuncts conjuncts)
               (qeval (first-conjunct conjuncts)
                      frame))))


(define (disjoin disjuncts frame)
  ;; Will fall into the interleave trap from before, though it's not really as big
  ;;  of a problem since our "universe" is (mostly) finite, and we expect our ambs to
  ;;  eventually reach an end state
  (require (not (empty-disjunction? disjuncts)))
  (amb
   (qeval (first-disjunct disjuncts) frame)
   (disjoin (rest-disjuncts disjuncts)
            frame)))

;;;Filters

(define (conjoin2 conjuncts frame)
  (if (empty-conjunction? conjuncts)
      #t
      (and (qeval2 (first-conjunct conjuncts)  frame)
           (conjoin2 (rest-conjuncts conjuncts) frame))))

(define (disjoin2 disjuncts frame)
  ;; A disjoin that doesn't use amb
  (or-lst (map (lambda (disjunct)
                 (qeval2 disjunct frame)) disjuncts)))


(define (qeval2 query frame)
  (let ((qproc (get (type query) 'qeval2)))
    (if qproc
        (qproc (contents query) frame)
        (simple-query2 query frame))))

(define (simple-query2 query-pattern frame)
  (or (find-assertions2 query-pattern frame)
      (apply-rules2 query-pattern frame)))

(define (apply-rules2 pattern frame)
  ;(display ('RULES-FETCHED: (fetch-rules pattern frame)))
  (let ((l
         (fetch-rules pattern frame)))
    (if l ;; If we have rules
        (or-lst (map ;; Do the same as before 
                 (lambda (rule) (apply-a-rule2 rule pattern frame))
                 l))
        #f ;; If not, signal that we don't
    )))


(define (apply-a-rule2 rule query-pattern query-frame)
  (let ((clean-rule (rename-variables-in rule)))
    (let ((unify-result
           (unify-match query-pattern
                        (conclusion clean-rule)
                        query-frame)))
      (if (eq? unify-result 'failed)
          #f
          (qeval2 (rule-body clean-rule)
                  unify-result)))))


(define (or-lst lst)
  (if (null? lst)
       #f
       (or (car lst) (or-lst (cdr lst)))))

(define (find-assertions2 pattern frame)
  (let ((lst (map (lambda (assertion)
                  (check-an-assertion2 assertion pattern frame))
                (fetch-assertions pattern frame))))
    (or-lst lst)))

(define (check-an-assertion2 assertion query-pat query-frame)
  (let ((match-result
         (pattern-match query-pat assertion query-frame)))
    (if (eq? match-result 'failed)
        #f
        match-result)))

(define (negate operands frame)
  (let
      ((res (qeval2 (negated-query operands) frame)))
    (if res
        (amb)
         frame)
    ))

(define (lisp-value call frame)
  (if (execute
       (instantiate
           call
         frame
         (lambda (v f)
           (error "Unknown pat var -- LISP-VALUE" v))))
      frame
      (amb)))


;; Crap for negate
(define (lisp-value2 call frame)
  (if (execute
       (instantiate
           call
         frame
         (lambda (v f)
           (error "Unknown pat var -- LISP-VALUE" v))))
      frame
      #f))

(define user-initial-environment (interaction-environment))

(define (execute exp)
  (apply (eval (car exp) (interaction-environment))
         (args exp)))

(define (always-true ignore frame) frame)

;;;SECTION 4.4.4.3
;;;Finding Assertions by Pattern Matching

(define (find-assertions pattern frame)
  (check-an-assertion (amb-lst (fetch-assertions pattern frame)) pattern frame))

(define (check-an-assertion assertion query-pat query-frame)
  (let ((match-result
         (pattern-match query-pat assertion query-frame)))
    (if (eq? match-result 'failed)
        (amb)
        match-result)))

(define (pattern-match pat dat frame)
  (cond ((eq? frame 'failed) 'failed)
        ((equal? pat dat) frame)
        ((var? pat) (extend-if-consistent pat dat frame))
        ((and (pair? pat) (pair? dat))
         (pattern-match (cdr pat)
                        (cdr dat)
                        (pattern-match (car pat)
                                       (car dat)
                                       frame)))
        (else 'failed)))

(define (extend-if-consistent var dat frame)
  (let ((binding (binding-in-frame var frame)))
    (if binding
        (pattern-match (binding-value binding) dat frame)
        (extend var dat frame))))

;;;SECTION 4.4.4.4
;;;Rules and Unification

(define (apply-rules pattern frame)
  (apply-a-rule (amb-lst (fetch-rules pattern frame)) pattern frame))


(define (apply-a-rule rule query-pattern query-frame)
  (let ((clean-rule (rename-variables-in rule)))
    (let ((unify-result
           (unify-match query-pattern
                        (conclusion clean-rule)
                        query-frame)))
      (if (eq? unify-result 'failed)
          (amb)
          (qeval (rule-body clean-rule)
                 unify-result)))))

(define (rename-variables-in rule)
  (let ((rule-application-id (new-rule-application-id)))
    (define (tree-walk exp)
      (cond ((var? exp)
             (make-new-variable exp rule-application-id))
            ((pair? exp)
             (cons (tree-walk (car exp))
                   (tree-walk (cdr exp))))
            (else exp)))
    (tree-walk rule)))

(define (unify-match p1 p2 frame)
  (cond ((eq? frame 'failed) 'failed)
        ((equal? p1 p2) frame)
        ((var? p1) (extend-if-possible p1 p2 frame))
        ((var? p2) (extend-if-possible p2 p1 frame)) ; {\em ; ***}
        ((and (pair? p1) (pair? p2))
         (unify-match (cdr p1)
                      (cdr p2)
                      (unify-match (car p1)
                                   (car p2)
                                   frame)))
        (else 'failed)))

(define (extend-if-possible var val frame)
  (let ((binding (binding-in-frame var frame)))
    (cond (binding
           (unify-match
            (binding-value binding) val frame))
          ((var? val)                     ; {\em ; ***}
           (let ((binding (binding-in-frame val frame)))
             (if binding
                 (unify-match
                  var (binding-value binding) frame)
                 (extend var val frame))))
          ((depends-on? val var frame)    ; {\em ; ***}
           'failed)
          (else (extend var val frame)))))

(define (depends-on? exp var frame)
  (define (tree-walk e)
    (cond ((var? e)
           (if (equal? var e)
               true
               (let ((b (binding-in-frame e frame)))
                 (if b
                     (tree-walk (binding-value b))
                     false))))
          ((pair? e)
           (or (tree-walk (car e))
               (tree-walk (cdr e))))
          (else false)))
  (tree-walk exp))

;;;SECTION 4.4.4.5
;;;Maintaining the Data Base

(define THE-ASSERTIONS '())

(define (fetch-assertions pattern frame)
  (if (use-index? pattern)
      (get-indexed-assertions pattern)
      (get-all-assertions)))

(define (get-all-assertions) THE-ASSERTIONS)

(define (get-indexed-assertions pattern)
  (get-2-keys (index-key-of pattern) 'assertion-list))

(define (get-2-keys key1 key2)
  (let ((s (get key1 key2)))
    (if s s '())))

(define THE-RULES '())

(define (fetch-rules pattern frame)
  (if (use-index? pattern)
      (get-indexed-rules pattern)
      (get-all-rules)))

(define (get-all-rules) THE-RULES)

(define (get-indexed-rules pattern)
  (append
   (get-2-keys (index-key-of pattern) 'rule-lst)
   (get-2-keys '? 'rule-lst)))

(define (add-rule-or-assertion! assertion)
  (if (rule? assertion)
      (add-rule! assertion)
      (add-assertion! assertion)))

(define (add-assertion! assertion)
  (store-assertion-in-index assertion)
  (let ((old-assertions THE-ASSERTIONS))
    (set! THE-ASSERTIONS
          (cons assertion old-assertions))
    'ok))

(define (add-rule! rule)
  (store-rule-in-index rule)
  (let ((old-rules THE-RULES))
    (set! THE-RULES (cons rule old-rules))
    'ok))

(define (store-assertion-in-index assertion)
  (if (indexable? assertion)
      (let ((key (index-key-of assertion)))
        (let ((current-assertions
               (get-2-keys key 'assertion-list)))
          (put key
               'assertion-list
               (cons assertion
                            current-assertions))))))

(define (store-rule-in-index rule)
  (let ((pattern (conclusion rule)))
    (if (indexable? pattern)
        (let ((key (index-key-of pattern)))
          (let ((current-rule-lst
                 (get-2-keys key 'rule-lst)))
            (put key
                 'rule-lst
                 (cons rule
                       current-rule-lst)))))))

(define (indexable? pat)
  (or (constant-symbol? (car pat))
      (var? (car pat))))

(define (index-key-of pat)
  (let ((key (car pat)))
    (if (var? key) '? key)))

(define (use-index? pat)
  (constant-symbol? (car pat)))


;;;SECTION 4.4.4.7
;;;Query syntax procedures

(define (type exp)
  (if (pair? exp)
      (car exp)
      (error "Unknown expression TYPE" exp)))

(define (contents exp)
  (if (pair? exp)
      (cdr exp)
      (error "Unknown expression CONTENTS" exp)))

(define (assertion-to-be-added? exp)
  (eq? (type exp) 'assert!))

(define (add-assertion-body exp)
  (car (contents exp)))

(define (empty-conjunction? exps) (null? exps))
(define (first-conjunct exps) (car exps))
(define (rest-conjuncts exps) (cdr exps))

(define (empty-disjunction? exps) (null? exps))
(define (first-disjunct exps) (car exps))
(define (rest-disjuncts exps) (cdr exps))

(define (negated-query exps) (car exps))

(define (predicate exps) (car exps))
(define (args exps) (cdr exps))


(define (rule? statement)
  (tagged-list? statement 'rule))

(define (conclusion rule) (cadr rule))

(define (rule-body rule)
  (if (null? (cddr rule))
      '(always-true)
      (caddr rule)))

(define (query-syntax-process exp)
  (if (eq? exp 'try-again)
      exp
      (map-over-symbols expand-question-mark exp)))

(define (map-over-symbols proc exp)
  (cond ((pair? exp)
         (cons (map-over-symbols proc (car exp))
               (map-over-symbols proc (cdr exp))))
        ((symbol? exp) (proc exp))
        (else exp)))

(define (expand-question-mark symbol)
  (let ((chars (symbol->string symbol)))
    (if (string=? (substring chars 0 1) "?")
        (list '?
              (string->symbol
               (substring chars 1 (string-length chars))))
        symbol)))

(define (var? exp)
  (tagged-list? exp '?))

(define (constant-symbol? exp) (symbol? exp))

(define rule-counter 0)

(define (new-rule-application-id)
  (set! rule-counter (+ 1 rule-counter))
  rule-counter)

(define (make-new-variable var rule-application-id)
  (cons '? (cons rule-application-id (cdr var))))

(define (contract-question-mark variable)
  (string->symbol
   (string-append "?" 
     (if (number? (cadr variable))
         (string-append (symbol->string (caddr variable))
                        "-"
                        (number->string (cadr variable)))
         (symbol->string (cadr variable))))))


;;;SECTION 4.4.4.8
;;;Frames and bindings
(define (make-binding variable value)
  (cons variable value))

(define (binding-variable binding)
  (car binding))

(define (binding-value binding)
  (cdr binding))


(define (binding-in-frame variable frame)
  (assoc variable frame))

(define (extend variable value frame)
  (cons (make-binding variable value) frame))


;;;;From Section 4.1

(define (tagged-list? exp tag)
  (if (pair? exp)
      (eq? (car exp) tag)
      false))

(define (prompt-for-input string)
  (newline) (newline) (display string) (newline))


;;;;Table support from Chapter 3, Section 3.3.3 (local tables)

(define (make-table)
  (let ((local-table (list '*table*)))
    (define (lookup key-1 key-2)
      (let ((subtable (assoc key-1 (cdr local-table))))
        (if subtable
            (let ((record (assoc key-2 (cdr subtable))))
              (if record
                  (cdr record)
                  false))
            false)))
    (define (insert! key-1 key-2 value)
      (let ((subtable (assoc key-1 (cdr local-table))))
        (if subtable
            (let ((record (assoc key-2 (cdr subtable))))
              (if record
                  (set-cdr! record value)
                  (set-cdr! subtable
                            (cons (cons key-2 value)
                                  (cdr subtable)))))
            (set-cdr! local-table
                      (cons (list key-1
                                  (cons key-2 value))
                            (cdr local-table)))))
      'ok)    
    (define (dispatch m)
      (cond ((eq? m 'lookup-proc) lookup)
            ((eq? m 'insert-proc!) insert!)
            (else (error "Unknown operation -- TABLE" m))))
    dispatch))

;;;; From instructor's manual

(define get '())

(define put '())

(define (initialize-data-base rules-and-assertions)
  (define (deal-out r-and-a rules assertions)
    (cond ((null? r-and-a)
           (set! THE-ASSERTIONS assertions)
           (set! THE-RULES rules)
           'done)
          (else
           (let ((s (query-syntax-process (car r-and-a))))
             (cond ((rule? s)
                    (store-rule-in-index s)
                    (deal-out (cdr r-and-a)
                              (cons s rules)
                              assertions))
                   (else
                    (store-assertion-in-index s)
                    (deal-out (cdr r-and-a)
                              rules
                              (cons s assertions))))))))
  (let ((operation-table (make-table)))
    (set! get (operation-table 'lookup-proc))
    (set! put (operation-table 'insert-proc!)))
  (put 'and 'qeval conjoin)
  (put 'or 'qeval disjoin)
  (put 'not 'qeval negate)
  (put 'lisp-value 'qeval lisp-value)
  (put 'always-true 'qeval always-true)

  ;; Crappy versions for negate
  (put 'and 'qeval2 conjoin2)
  (put 'or 'qeval2 disjoin2)
  (put 'lisp-value 'qeval2 lisp-value2)
  (deal-out rules-and-assertions '() '()))

;; Do following to reinit the data base from microshaft-data-base
;;  in Scheme (not in the query driver loop)
;; (initialize-data-base microshaft-data-base)

(define microshaft-data-base
  '(
;; from section 4.4.1
(address (Bitdiddle Ben) (Slumerville (Ridge Road) 10))
(job (Bitdiddle Ben) (computer wizard))
(salary (Bitdiddle Ben) 60000)

(address (Hacker Alyssa P) (Cambridge (Mass Ave) 78))
(job (Hacker Alyssa P) (computer programmer))
(salary (Hacker Alyssa P) 40000)
(supervisor (Hacker Alyssa P) (Bitdiddle Ben))

(address (Fect Cy D) (Cambridge (Ames Street) 3))
(job (Fect Cy D) (computer programmer))
(salary (Fect Cy D) 35000)
(supervisor (Fect Cy D) (Bitdiddle Ben))

(address (Tweakit Lem E) (Boston (Bay State Road) 22))
(job (Tweakit Lem E) (computer technician))
(salary (Tweakit Lem E) 25000)
(supervisor (Tweakit Lem E) (Bitdiddle Ben))

(address (Reasoner Louis) (Slumerville (Pine Tree Road) 80))
(job (Reasoner Louis) (computer programmer trainee))
(salary (Reasoner Louis) 30000)
(supervisor (Reasoner Louis) (Hacker Alyssa P))

(supervisor (Bitdiddle Ben) (Warbucks Oliver))

(address (Warbucks Oliver) (Swellesley (Top Heap Road)))
(job (Warbucks Oliver) (administration big wheel))
(salary (Warbucks Oliver) 150000)

(address (Scrooge Eben) (Weston (Shady Lane) 10))
(job (Scrooge Eben) (accounting chief accountant))
(salary (Scrooge Eben) 75000)
(supervisor (Scrooge Eben) (Warbucks Oliver))

(address (Cratchet Robert) (Allston (N Harvard Street) 16))
(job (Cratchet Robert) (accounting scrivener))
(salary (Cratchet Robert) 18000)
(supervisor (Cratchet Robert) (Scrooge Eben))

(address (Aull DeWitt) (Slumerville (Onion Square) 5))
(job (Aull DeWitt) (administration secretary))
(salary (Aull DeWitt) 25000)
(supervisor (Aull DeWitt) (Warbucks Oliver))

(can-do-job (computer wizard) (computer programmer))
(can-do-job (computer wizard) (computer technician))

(can-do-job (computer programmer)
            (computer programmer trainee))

(can-do-job (administration secretary)
            (administration big wheel))

(rule (lives-near ?person-1 ?person-2)
      (and (address ?person-1 (?town . ?rest-1))
           (address ?person-2 (?town . ?rest-2))
           (not (same ?person-1 ?person-2))))

(rule (same ?x ?x))

(rule (wheel ?person)
      (and (supervisor ?middle-manager ?person)
           (supervisor ?x ?middle-manager)))

(rule (outranked-by ?staff-person ?boss)
      (or (supervisor ?staff-person ?boss)
          (and (supervisor ?staff-person ?middle-manager)
               (outranked-by ?middle-manager ?boss))))

;; Add troublesome loopy case
(married Minnie Mickey)

(rule (married ?x ?y)
      (married ?y ?x))

))

(initialize-data-base microshaft-data-base)
