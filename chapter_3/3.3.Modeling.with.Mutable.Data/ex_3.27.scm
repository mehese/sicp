#lang sicp

(define (make-table)
  (define (create-empty-node) (list #f #f '() '()))
  (define (get-key tree) (car tree))
  (define (set-root-key! tree key) (set-car! tree key))
  (define (set-root-value! tree value) (set-cdr! tree (cons value (cddr tree))))
  (define (get-value tree) (cadr tree))
  (define (left-node tree) (caddr tree))
  (define (right-node tree) (cadddr tree))
  (define (set-left-node! tree contents)
    (set-cdr! tree (list (get-value tree) contents (right-node tree))))  
  (define (set-right-node! tree contents)
    (set-cdr! tree (list (get-value tree) (left-node tree) contents)))
  
  (let
      ((local-table (create-empty-node)))
    (define (lookup key)
      (define (lookup-rec tree)
        (let
            ((root-key (get-key tree)))
          (cond
            ((not root-key) root-key)
            ((eq? root-key key) (cons key (get-value tree)))
            ((< key root-key) (lookup-rec (left-node tree)))
            ((> key root-key) (lookup-rec (right-node tree)))
            (else (error "Got stuck when looking up key" key)))))
      (lookup-rec local-table))

    
    (define (insert! key value)
      (define (insert-rec tree)
        (cond
          ((not (get-key tree)) (set-root-key! tree key)
                                (set-root-value! tree value)
                                (set-left-node! tree (create-empty-node))
                                (set-right-node! tree (create-empty-node)))
          ((eq? (get-key tree) key) (set-root-value! tree value))
          ((< key (get-key tree)) (insert-rec (left-node tree)))
          ((> key (get-key tree)) (insert-rec (right-node tree)))          
          (else (error "Can't decide how to insert this"))))    
      (insert-rec local-table))

    (define (dispatch m)
       (cond ((eq? m 'lookup-proc) lookup)
             ((eq? m 'insert-proc!) insert!)
             ((eq? m 'innards) local-table)
             (else (error "Unknown operation: TABLE" m)))) 
    dispatch))
(define (lookup value table)
  (let ((query-res ((table 'lookup-proc) value)))
    (if query-res
        (cdr query-res)
        query-res)))
(define (insert! key value table) ((table 'insert-proc!) key value))


(define (fib n)
  (cond ((= n 0) 0)
        ((= n 1) 1)
        (else (+ (fib (- n 1))
                 (fib (- n 2))))))

(define (memoize f)
  (let ((table (make-table)))
    (lambda (x)
      (let ((previously-computed-result 
             (lookup x table)))
        ;; TIL or doesn't return #t or #f, but the first true value!
        (or previously-computed-result
            (let ((result (f x)))
              (insert! x result table)
              result))))))

(define memo-fib
  ;; Tfw decorators aren't implemented in the standard...
  (memoize 
   (lambda (n)
     (cond ((= n 0) 0)
           ((= n 1) 1)
           (else 
            (+ (memo-fib (- n 1))
               (memo-fib (- n 2))))))))

(define t0 (runtime))
(fib 40)
(display (list "time to run fib (vanilla)" (- (runtime) t0))) (newline)

(set! t0 (runtime))
(memo-fib 40)
(display (list "time to run fib with memo" (- (runtime) t0))) (newline)

;; Bonus
(set! t0 (runtime))
((memoize fib) 40)
(display (list "time to run (memoize fib)" (- (runtime) t0))) (newline)
