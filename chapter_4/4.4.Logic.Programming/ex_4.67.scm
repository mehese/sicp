#lang sicp
(#%require (only racket/base make-hash))
(#%require (only racket/base hash-set!))
(#%require (only racket/base hash-ref))
(#%require (only racket/base hash-keys))
(#%require (only racket/base hash-remove!))
(#%require (only racket/base hash-clear!))

;Devise a way to install a loop detector in the query system so as to avoid the kinds of
;simple loops illustrated in the text and in Exercise 4.64. The general idea is that the
;system should maintain some sort of history of its current chain of deductions and should
;not begin processing a query that it is already working on. Describe what kind of
;information (patterns and frames) is included in this history, and how the check should
;be made.

;; In apply a rule we check whether the task we're working on is still being worked on. The
;;  first think we need is a hash table (see imports above). Then we need of a way to identify
;;  unique queries in that table -- for this I used the query pattern + the set of unique
;;  bindings in the frame. For this we need to remove the ever increasing indices from the
;;  query & the frame. So in apply-a-rule we check to see if the current query pattern is being
;;  processed. If it is, we return the empty stream. If not add the task to the table and and
;;  process it.

;; Now the following queries will work a-ok

'(married Minnie ?who)

'(married Mickey ?who)

'(loopy-outranked-by ?x ?y)


;; Global table that contains the tasks we're working on
(define *CURRENT-TASKS* (make-hash))

(define input-prompt ";;; Query input:")
(define output-prompt ";;; Query results:")

(define (clear-query-pattern rule)
  ;; query patterns get that little incremented index which stands in the way of us from
  ;;  checking if a previous version was added to a hash table. This function removes that
  ;;  nasty nonce
  (define (iterate-elems rest-of-rule rule-so-far)
    (cond
      ((null? rest-of-rule) rule-so-far)
      ;; It's a plain-ole symbol
      ((symbol? (car rest-of-rule))
       (iterate-elems (cdr rest-of-rule)
                      (append rule-so-far (list (car rest-of-rule)))))
      ;; Not a variable / or already clear-formed
      ((and (pair? (car rest-of-rule)) (or (not (eq? '? (caar rest-of-rule)))
                                           (not (number? (cadar rest-of-rule)))))
       (iterate-elems (cdr rest-of-rule)
                      (append rule-so-far (list (car rest-of-rule)))))
      ;; A variable, needs clearing
      ((and (pair? (car rest-of-rule)) (eq? '? (caar rest-of-rule)))
       (let*
           ((this-elem (car rest-of-rule))
            (this-elem-cleaned (list '? (caddr this-elem))))
         (iterate-elems (cdr rest-of-rule)
                        (append rule-so-far (list this-elem-cleaned)))))))
       
  (iterate-elems rule '()))

(define (clean-binding binding)
  (define (clear-var var)
    (cond
      ((and (pair? var) (eq? '? (car var)) (number? (cadr var)))
       (list '? (caddr var)))
      (else var)))
  
  (let
      ((left (car binding))
       (right (cdr binding)))
    (list (clear-var left) (clear-var right))))
       
(define (same-binding? a b)
  (define (same-var? a b)
    (or (eq? a b)
        (and (pair? a) (pair? b)
             (eq? '? (car a)) (eq? '? (car b))
             (eq? (cadr a) (cadr b)))))
  (let
      ((ax (car a))
       (ay (cadr a))
       (bx (car b))
       (by (cadr b)))
    (if (and (same-var? ax bx) (same-var? ay by))
        #t
        #f)))

(define (unique-bindings bindings)
  ;; Generates the set of unique bindings
  
  (define (not-in binding-lst bind)
    (if (null? binding-lst)
        #t ;; stopping condition
        (if (same-binding? (car binding-lst) bind)
            #f ;; the binding is in the list we're checking
            (not-in (cdr binding-lst) bind)))) ;; check the rest
  
  (define (iter-bindings remaining uniques)
    (cond
      ;; Checked them all -- return
      ((null? remaining) uniques)
      ;; The current item is not in unique -- add it to the unique list
      ((not-in uniques (car remaining))
       (iter-bindings (cdr remaining) (cons (car remaining) uniques)))
      (else
       (iter-bindings (cdr remaining) uniques))))
  (iter-bindings bindings '()))

  

(define (get-unique-bindings-set frame)
  (let
      ((cleaned-up-bindings (map clean-binding frame)))
  (unique-bindings cleaned-up-bindings)))

(define (generate-query-key q-pat q-frame)
  ;; Query pattern + unique bindings = Key to identify a query that's being processed
  (let
      ((clean-pattern (clear-query-pattern q-pat))
       (unique-bindings (get-unique-bindings-set q-frame)))

    (cons clean-pattern unique-bindings)))

(define (query-driver-loop)
  ;; If we interrupt the driver loop we would probably like to start with a clean
  ;;  slate
  (hash-clear! *CURRENT-TASKS*)
  (prompt-for-input input-prompt)
  (let ((q (query-syntax-process (read))))
    (cond ((assertion-to-be-added? q)
           (add-rule-or-assertion! (add-assertion-body q))
           (newline)
           (display "Assertion added to data base.")
           (query-driver-loop))
          (else
           (newline)
           (display output-prompt)
           ;; [extra newline at end] (announce-output output-prompt)
           (display-stream
            (stream-map
             (lambda (frame)
               (instantiate q
                            frame
                            (lambda (v f)
                              (contract-question-mark v))))
             (qeval q (singleton-stream '()))))
           ;; Just in case there's some leftover trash in the table, clear it
           (hash-clear! *CURRENT-TASKS*)
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

(define (qeval query frame-stream)
  (let ((qproc (get (type query) 'qeval)))
    (if qproc
        (qproc (contents query) frame-stream)
        (simple-query query frame-stream))))

;;;Simple queries

(define (simple-query query-pattern frame-stream)
  (stream-flatmap
   (lambda (frame)
     (stream-append-delayed
      (find-assertions query-pattern frame)
      (delay (apply-rules query-pattern frame))))
   frame-stream))

;;;Compound queries

(define (conjoin conjuncts frame-stream)
  (if (empty-conjunction? conjuncts)
      frame-stream
      (conjoin (rest-conjuncts conjuncts)
               (qeval (first-conjunct conjuncts)
                      frame-stream))))

;;(put 'and 'qeval conjoin)


(define (disjoin disjuncts frame-stream)
  (if (empty-disjunction? disjuncts)
      the-empty-stream
      (interleave-delayed
       (qeval (first-disjunct disjuncts) frame-stream)
       (delay (disjoin (rest-disjuncts disjuncts)
                       frame-stream)))))

;;(put 'or 'qeval disjoin)

;;;Filters

(define (negate operands frame-stream)
  (stream-flatmap
   (lambda (frame)
     (if (stream-null? (qeval (negated-query operands)
                              (singleton-stream frame)))
         (singleton-stream frame)
         the-empty-stream))
   frame-stream))

;;(put 'not 'qeval negate)

(define (lisp-value call frame-stream)
  (stream-flatmap
   (lambda (frame)
     (if (execute
          (instantiate
           call
           frame
           (lambda (v f)
             (error "Unknown pat var -- LISP-VALUE" v))))
         (singleton-stream frame)
         the-empty-stream))
   frame-stream))

;;(put 'lisp-value 'qeval lisp-value)

(define user-initial-environment (interaction-environment))

(define (execute exp)
  (apply (eval (car exp) (interaction-environment))
         (args exp)))

(define (always-true ignore frame-stream) frame-stream)

;;(put 'always-true 'qeval always-true)

;;;SECTION 4.4.4.3
;;;Finding Assertions by Pattern Matching

(define (find-assertions pattern frame)
  (stream-flatmap (lambda (datum)
                    (check-an-assertion datum pattern frame))
                  (fetch-assertions pattern frame)))

(define (check-an-assertion assertion query-pat query-frame)
  (let ((match-result
         (pattern-match query-pat assertion query-frame)))
    (if (eq? match-result 'failed)
        the-empty-stream
        (singleton-stream match-result))))

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
  (stream-flatmap (lambda (rule)
                    (apply-a-rule rule pattern frame))
                  (fetch-rules pattern frame)))

(define (apply-a-rule rule query-pattern query-frame)
  (let ((clean-rule (rename-variables-in rule)))
    (let ((unify-result
           (unify-match query-pattern
                        (conclusion clean-rule)
                        query-frame)))
      (if (eq? unify-result 'failed)
          the-empty-stream
          (let
              ((current-task-key (generate-query-key query-pattern query-frame)))
            (if (hash-ref *CURRENT-TASKS* current-task-key #f)
                the-empty-stream              
                (begin
                
                  (hash-set! *CURRENT-TASKS* current-task-key 'processing)
                  (qeval (rule-body clean-rule)
                         (singleton-stream unify-result)))))))))

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

(define THE-ASSERTIONS the-empty-stream)

(define (fetch-assertions pattern frame)
  (if (use-index? pattern)
      (get-indexed-assertions pattern)
      (get-all-assertions)))

(define (get-all-assertions) THE-ASSERTIONS)

(define (get-indexed-assertions pattern)
  (get-stream (index-key-of pattern) 'assertion-stream))

(define (get-stream key1 key2)
  (let ((s (get key1 key2)))
    (if s s the-empty-stream)))

(define THE-RULES the-empty-stream)

(define (fetch-rules pattern frame)
  (if (use-index? pattern)
      (get-indexed-rules pattern)
      (get-all-rules)))

(define (get-all-rules) THE-RULES)

(define (get-indexed-rules pattern)
  (stream-append
   (get-stream (index-key-of pattern) 'rule-stream)
   (get-stream '? 'rule-stream)))

(define (add-rule-or-assertion! assertion)
  (if (rule? assertion)
      (add-rule! assertion)
      (add-assertion! assertion)))

(define (add-assertion! assertion)
  (store-assertion-in-index assertion)
  (let ((old-assertions THE-ASSERTIONS))
    (set! THE-ASSERTIONS
          (cons-stream assertion old-assertions))
    'ok))

(define (add-rule! rule)
  (store-rule-in-index rule)
  (let ((old-rules THE-RULES))
    (set! THE-RULES (cons-stream rule old-rules))
    'ok))

(define (store-assertion-in-index assertion)
  (if (indexable? assertion)
      (let ((key (index-key-of assertion)))
        (let ((current-assertion-stream
               (get-stream key 'assertion-stream)))
          (put key
               'assertion-stream
               (cons-stream assertion
                            current-assertion-stream))))))

(define (store-rule-in-index rule)
  (let ((pattern (conclusion rule)))
    (if (indexable? pattern)
        (let ((key (index-key-of pattern)))
          (let ((current-rule-stream
                 (get-stream key 'rule-stream)))
            (put key
                 'rule-stream
                 (cons-stream rule
                              current-rule-stream)))))))

(define (indexable? pat)
  (or (constant-symbol? (car pat))
      (var? (car pat))))

(define (index-key-of pat)
  (let ((key (car pat)))
    (if (var? key) '? key)))

(define (use-index? pat)
  (constant-symbol? (car pat)))

;;;SECTION 4.4.4.6
;;;Stream operations


(define-syntax cons-stream
  (syntax-rules ()
    ((_ a b) (cons a (delay b)))))

(define (stream-car stream) 
  (car stream))

(define (stream-cdr stream) 
  (force (cdr stream)))

(define (stream-append-delayed s1 delayed-s2)
  (if (stream-null? s1)
      (force delayed-s2)
      (cons-stream
       (stream-car s1)
       (stream-append-delayed (stream-cdr s1) delayed-s2))))

(define (interleave-delayed s1 delayed-s2)
  (if (stream-null? s1)
      (force delayed-s2)
      (cons-stream
       (stream-car s1)
       (interleave-delayed (force delayed-s2)
                           (delay (stream-cdr s1))))))

(define (stream-flatmap proc s)
  (flatten-stream (stream-map proc s)))

(define (flatten-stream stream)
  (if (stream-null? stream)
      the-empty-stream
      (interleave-delayed
       (stream-car stream)
       (delay (flatten-stream (stream-cdr stream))))))


(define (singleton-stream x)
  (cons-stream x the-empty-stream))


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
  (map-over-symbols expand-question-mark exp))

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


;;;;Stream support from Chapter 3

(define (stream-map proc s)
  (if (stream-null? s)
      the-empty-stream
      (cons-stream (proc (stream-car s))
                   (stream-map proc (stream-cdr s)))))

(define (stream-for-each proc s)
  (if (stream-null? s)
      'done
      (begin (proc (stream-car s))
             (stream-for-each proc (stream-cdr s)))))

(define (display-stream s)
  (stream-for-each display-line s))
(define (display-line x)
  (newline)
  (display x))

(define (stream-filter pred stream)
  (cond ((stream-null? stream) the-empty-stream)
        ((pred (stream-car stream))
         (cons-stream (stream-car stream)
                      (stream-filter pred
                                     (stream-cdr stream))))
        (else (stream-filter pred (stream-cdr stream)))))

(define (stream-append s1 s2)
  (if (stream-null? s1)
      s2
      (cons-stream (stream-car s1)
                   (stream-append (stream-cdr s1) s2))))

(define (interleave s1 s2)
  (if (stream-null? s1)
      s2
      (cons-stream (stream-car s1)
                   (interleave s2 (stream-cdr s1)))))

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


(define (list->stream lst)
  (if (null? lst)
      '()
      (cons-stream (car lst) (list->stream (cdr lst)))))

(define (initialize-data-base rules-and-assertions)
  (define (deal-out r-and-a rules assertions)
    (cond ((null? r-and-a)
           (set! THE-ASSERTIONS (list->stream assertions))
           (set! THE-RULES (list->stream rules))
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


;; Add troublesome loopy stuff
(married Minnie Mickey)

(rule (married ?x ?y)
      (married ?y ?x))

(rule (loopy-outranked-by ?staff-person ?boss)
          (or (supervisor ?staff-person ?boss)
              (and (loopy-outranked-by ?middle-manager ?boss)
                   (supervisor ?staff-person ?middle-manager))))


))

(initialize-data-base microshaft-data-base)