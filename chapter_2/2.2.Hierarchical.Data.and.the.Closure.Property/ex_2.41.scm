#lang sicp

;; The joy of imports
(define (accumulate op initial sequence)
  (if (null? sequence)
      initial
      (op (car sequence)
          (accumulate op 
                      initial 
                      (cdr sequence)))))

(define (filter predicate sequence)
  (cond ((null? sequence) nil)
        ((predicate (car sequence))
         (cons (car sequence)
               (filter predicate 
                       (cdr sequence))))
        (else  (filter predicate 
                       (cdr sequence)))))

;; From Ex 2.40
(define (unique-pairs n)
  (define (gen-pair i j)
    (cond
      ((= i j) (gen-pair (inc i) 1))
      ((= j (dec n)) (list (list i j)))
      (else (cons (list i j) (gen-pair i (inc j))))))
  (gen-pair 2 1))

;; Solution
(define (sums-to-s? lst s)
  (= s (accumulate + 0 lst)))

(define (unique-triplets n)
  (define (gen-triplets k)
    (if (= k n)
        (map (lambda (p) (append (list k)  p)) (unique-pairs (dec n)))
        (append
         (gen-triplets (inc k))
         (map (lambda (p) (append p (list k))) (unique-pairs (dec k)))
         )))

  (gen-triplets 3))

(define (solution n s)
  (filter
   (lambda (triplet) (sums-to-s? triplet s))
   (unique-triplets n)))

;; Check solution
(solution 5 6) ; ✔
(solution 5 7) ; ✔
(solution 5 8) ; ✔
(solution 5 9) ; ✔
(solution 5 10) ; ✔
(solution 5 11) ; ✔
(solution 5 12) ; ✔

(solution 100 297) ; ✔