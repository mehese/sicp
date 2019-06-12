#lang sicp

;; Since the N-queens was similar let's import stuff back from 2.2
(define (accumulate op initial sequence)
  (if (null? sequence)
      initial
      (op (car sequence)
          (accumulate op 
                      initial 
                      (cdr sequence)))))

(define (flatmap proc seq)
  (accumulate append nil (map proc seq)))

(define (filter predicate sequence)
  (cond ((null? sequence) nil)
        ((predicate (car sequence))
         (cons (car sequence)
               (filter predicate 
                       (cdr sequence))))
        (else  (filter predicate 
                       (cdr sequence)))))

(define (remove item sequence)
  (filter (lambda (x) (not (= x item)))
          sequence))

(define (permutations s)
  (if (null? s)   ; empty set?
      (list nil)  ; sequence containing empty set
      (flatmap (lambda (x)
                 (map (lambda (p) 
                        (cons x p))
                      (permutations 
                       (remove x s))))
               s)))



;; Not the most elegant solution, but it does the job. Sure, the problem probably needed
;;  to be mapped on the entire 5^5 possible values of floor placements, with an extra check
;;  in the filter to verify that the solution contains only distinct floors, but the book
;;  already contains a neat permutations function but no itertools.product equivalent out of
;;  the box

(define (multiple-dwelling)
  (map
   name-solution
   (filter
    (lambda (candidate-solution)
      (and (not (= (baker candidate-solution) 5))
           (not (= (cooper candidate-solution) 1))
           (not (= (fletcher candidate-solution) 5))
           (not (= (fletcher candidate-solution) 1))
           (> (miller candidate-solution) (cooper candidate-solution))
           (not (= (abs (- (smith candidate-solution) (fletcher candidate-solution))) 1))
           (not (= (abs (- (cooper candidate-solution) (fletcher candidate-solution))) 1))
           #t))
    (permutations '(1 2 3 4 5))))) ;; saves us the distinct check


;; helpers
(define (baker sol)
  (car sol))

(define (cooper sol)
  (cadr sol))

(define (fletcher sol)
  (caddr sol))

(define (miller sol)
  (cadddr sol))

(define (smith sol)
  (cadr (cdddr sol)))

(define (name-solution sol)
  (define names '(baker cooper fletcher miller smith))
  (define (name names-left sol-left)
    (if (null? names-left)
        '()
        (cons (list (car names-left) (car sol-left))
              (name (cdr names-left) (cdr sol-left)))))
  (name names sol))