#lang sicp

(define xor
  (lambda (a b)
    (cond
      (a (not b))
      (else b))))

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

;; Again, not the most efficient way of going about it, but that's why we've got 21st
;;  century levels of RAM and CPU
(define (liars)
  (map
   name-solution
   (filter
    (lambda (sol)
      (and #t
           ;; Betty: “Kitty was second in the examination. I was only third.”
           (xor (= (kitty sol) 2) (= (betty sol) 3))
           ;; Ethel: “You’ll be glad to hear that I was on top. Joan was second.”
           (xor (= (ethel sol) 1) (= (joan sol) 2))
           ;; Joan: “I was third, and poor old Ethel was bottom.”
           (xor (= (joan sol) 3) (= (ethel sol) 5))
           ;; Kitty: “I came out second. Mary was only fourth.”
           (xor (= (kitty sol) 2) (= (mary sol) 4))
           ;; Mary: “I was fourth. Top place was taken by Betty.”
           (xor (= (mary sol) 4) (= (betty sol) 1))
           #t))
    (permutations '(1 2 3 4 5))))) ;; saves us the distinct check

;; {{{betty 3} {ethel 5} {joan 2} {kitty 1} {mary 4}}}

;; helpers
(define (betty sol)
  (car sol))

(define (ethel sol)
  (cadr sol))

(define (joan sol)
  (caddr sol))

(define (kitty sol)
  (cadddr sol))

(define (mary sol)
  (cadr (cdddr sol)))

(define (name-solution sol)
  (define names '(betty ethel joan kitty mary))
  (define (name names-left sol-left)
    (if (null? names-left)
        '()
        (cons (list (car names-left) (car sol-left))
              (name (cdr names-left) (cdr sol-left)))))
  (name names sol))