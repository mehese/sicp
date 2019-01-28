#lang sicp

(define (fold-right op initial sequence)
  (if (null? sequence)
      initial
      (op (car sequence)
          (fold-right op 
                      initial 
                      (cdr sequence)))))

(define (fold-left op initial sequence)
  (define (iter result rest)
    (if (null? rest)
        result
        (iter (op result (car rest))
              (cdr rest))))
  (iter initial sequence))

;; fold-left = fold-right across an operation for any sequence S[Type]
;;  for an operation ∧ if and only if (a ∧ b) ∧ c = a ∧ (b ∧ c) ∀ a, b,c  ∈ Set[Type]
;;  i.e. the operation must be associative with respect to the possible items in S

(display "Associative operations")
(newline)
(fold-left  + 0 (list 91 2 32 44 434839))
(fold-right  + 0 (list 91 2 32 44 434839))


(fold-left  * 1 (list 91 2 32 44 434839))
(fold-right  * 1 (list 91 2 32 44 434839))

(fold-left  max 0 (list 91 2 32 44 434839))
(fold-right  max 0 (list 91 2 32 44 434839))

; list appending is non commutative but associative!
(fold-left  append nil (list (list 1) (list 2) (list 9999)))
(fold-right  append nil (list (list 1) (list 2) (list 9999)))

(display "Non associative operations")
(newline)
(fold-right / 1 (list 1 2 3)) ; 1 1/2
(fold-left  / 1 (list 1 2 3)) ; 1/6

(fold-right list nil (list 1 2 3)) ; {1 {2 {3 ()}}}
(fold-left  list nil (list 1 2 3)) ; {{{() 1} 2} 3}

(fold-right cons nil (list 1 2 3))
(fold-left  cons nil (list 1 2 3))
