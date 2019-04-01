#lang sicp

(define (make-table same-key?)
  (let ((local-table (list '*table*)))

    (define (lookup key)
      (let ((record (assoc key (cdr local-table))))
        (if record
            (cdr record)
            false)))

    (define (assoc key records)
      (cond ((null? records) false)
            ((same-key? key (caar records)) 
             (car records))
            (else (assoc key (cdr records)))))
    
    (define (insert! key value)
      (let ((record (assoc key (cdr local-table))))
        (if record
            (set-cdr! record value)
            (set-cdr! local-table
                      (cons (cons key value) 
                            (cdr local-table)))))
      'ok)
    
    (define (dispatch m)
      (cond ((eq? m 'lookup-proc) lookup)
            ((eq? m 'insert-proc!) insert!)
            (else (error "Unknown operation: 
                          TABLE" m))))
    dispatch))

(define (insert! table key record) ((table 'insert-proc!) key record))
(define (lookup table value) ((table 'lookup-proc) value))


(define (same-key candidate key)
  (<= (abs (- candidate key)) 2))

(define tab (make-table same-key))

(insert! tab 5 "almost 5")
(insert! tab 15 "almost 15")
(insert! tab 112 "almost 112")

(lookup tab 4) ; ✔
(lookup tab 5) ; ✔
(lookup tab 110) ; ✔
(lookup tab 116) ; ✔