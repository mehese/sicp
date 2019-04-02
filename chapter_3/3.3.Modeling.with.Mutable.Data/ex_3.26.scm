#lang sicp


(define (make-binary-table)

  (define (create-empty-node)
    (list #f #f '() '()))

  (define (get-key tree)
    (car tree))

  (define (set-root-key! tree key)
    (set-car! tree key))

  (define (set-root-value! tree value)
    (set-cdr! tree (cons value (cddr tree))))

  (define (get-value tree)
    (cadr tree))

  (define (left-node tree)
    (caddr tree))
  
  (define (right-node tree)
    (cadddr tree))

  (define (set-left-node! tree contents)
    (set-cdr! tree (list (get-value tree)
                         contents
                         (right-node tree))))
  
  (define (set-right-node! tree contents)
    (set-cdr! tree (list (get-value tree)
                         (left-node tree)
                         contents)))
  
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
          ;; Key doesn't exist, insert it
          ((not (get-key tree))
           (set-root-key! tree key)
           (set-root-value! tree value)
           (set-left-node! tree (create-empty-node))
           (set-right-node! tree (create-empty-node)))
          ;; Key exists, update value
          ((eq? (get-key tree) key)
           (set-root-value! tree value))
          ;; Key is smaller, go left
          ((< key (get-key tree))
           (insert-rec (left-node tree)))
          ;; Key is bigger, go right
          ((> key (get-key tree))
           (insert-rec (right-node tree)))          
          (else (error "Can't decide how to insert this"))))
      
      (insert-rec local-table))

    
    (define (dispatch m)
       (cond ((eq? m 'lookup-proc) lookup)
             ((eq? m 'insert-proc!) insert!)
             ((eq? m 'innards) local-table)
             (else (error "Unknown operation: TABLE" m)))) 
    dispatch))

(define (lookup table value) ((table 'lookup-proc) value))
(define (insert! table key value) ((table 'insert-proc!) key value))
(define (print table) (table 'innards))

(define tab (make-binary-table))

(lookup tab 2); ✔ 

(insert! tab 5 'five)
(insert! tab 5 'five-new)
(insert! tab 2 'two)
(insert! tab 7 'seven)
(insert! tab 6 'six)
(insert! tab 2 'two-new)
(print tab)
(lookup tab 2); ✔ 
(lookup tab 666); ✔ 
(lookup tab 6); ✔ 
(lookup tab 5); ✔ 
