#lang sicp

;; Some solutions on the internet just use the code from Ex 3.24 and
;;  use a symbol list as a key. I think the problem is actually more
;;  difficult and requires generalising the 2D tables.
;;
;; There is one tiny issue which will make it hard to generalize that.
;;  Let's imagine we call:
;;   (insert! table '(a) "a")
;;   (insert! table '(a b) "a & b")
;;  Basically under the node 'a we should contain both a value and a list
;;   of possible keys!.
;;
;;  This leads me to think that the second node (after the head node which
;;   contains the name) in any linked list should be reserved for storing
;;   the value at calling that key
;;   
(define (make-table)
  
  (define (create-fresh-table name value)
    (cons name
          (cons value nil)))
  
  (let ((local-table (create-fresh-table '*table* 'RESERVED)))

    (define (assoc key records)
      (cond ((null? records) #f)
            ((eq? key (caar records)) (car records))
            (else (assoc key (cdr records)))))

    (define (lookup key-list)
      #f)

    (define (one-item? lst)
      (null? (cdr lst)))

    (define (records table)
      (cddr table))

    (define (insert-or-update-record table key value)
      (let
          ((record (assoc key (records table))))
        (if record
            (begin
              (display "Updating existing record")
              (let
                  ((contents-to-keep (cddr record)))
                (set-cdr! record (cons value contents-to-keep))
              (newline)))
            (begin
              (display "Inserting new record") (display (list key value))
              (let
                  ((new-record (create-fresh-table key value)))
                (set-cdr! table (cons (cadr table)
                                      (cons new-record (cddr table)))))
              (newline)))))
    
    (define (insert! key-list value)
      (define (insert-rec keys table)
        (if (one-item? key-list)
            (begin
              ;(display "Inserting value") (newline)
              (insert-or-update-record table  (car key-list) value)
              (display local-table) (newline))
            'inserting-more-keys))
      
      (insert-rec key-list local-table))
    
    (define (dispatch m)
      (cond ((eq? m 'lookup-proc) lookup)
            ((eq? m 'insert-proc!) insert!)
            ((eq? m 'innards) local-table)
            (else (error "Unknown operation: 
                          TABLE" m))))
    dispatch))

(define (insert! table key-list record) ((table 'insert-proc!) key-list record))
(define (lookup table key-list) ((table 'lookup-proc) key-list))

(define tab1 (make-table))
(insert! tab1 '(a) "aaa")
(insert! tab1 '(b) "bbb")
(insert! tab1 '(a) "anew")
;(insert! tab1 '(a b) "a & b")