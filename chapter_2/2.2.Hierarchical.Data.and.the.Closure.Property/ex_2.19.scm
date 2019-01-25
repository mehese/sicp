#lang sicp

(display "Old method") (newline)

(define (count-change amount)
  (cc-old amount 5))

(define (cc-old amount kinds-of-coins)
  (cond ((= amount 0) 1)
        ((or (< amount 0) 
             (= kinds-of-coins 0)) 
         0)
        (else 
         (+ (cc-old amount (- kinds-of-coins 1))
            (cc-old (- amount (first-denomination-old 
                           kinds-of-coins))
                kinds-of-coins)))))

(define (first-denomination-old kinds-of-coins)
  (cond ((= kinds-of-coins 1) 1)
        ((= kinds-of-coins 2) 5)
        ((= kinds-of-coins 3) 10)
        ((= kinds-of-coins 4) 25)
        ((= kinds-of-coins 5) 50)))

(count-change 100)

(display "New method") (newline)

(define (no-more? lst)
  (null? lst))

(define (except-first-denomination lst)
  (cdr lst))

(define (first-denomination lst)
  (car lst))

(define (cc amount coin-values)
  (cond ((= amount 0) 
         1)
        ((or (< amount 0) 
             (no-more? coin-values)) 
         0)
        (else
         (+ (cc 
             amount
             (except-first-denomination 
              coin-values))
            (cc 
             (- amount
                (first-denomination 
                 coin-values))
             coin-values)))))

(define us-coins 
  (list 50 25 10 5 1))


(define uk-coins 
  (list 100 50 20 10 5 2 1 0.5))

(cc 100 us-coins)

;; let's check if order matters
(display "Check importance of order") (newline)

(define us-coins-check 
  (list 50 5 10 25 1))

(define uk-coins-check 
  (list 100 50 20 2 5 10 0.5 1))

(cc 100 us-coins-check) ;; Nope
(display (cons (cc 100 uk-coins) (cc 100 uk-coins-check)))  ;; Nope in uk too

;; Why it doesn't matter
;;  The fact that one denomination is larger or smaller than the previous one in the
;;  list given is not important in neither of the implementations.
;;  Remember the algorithm
;;     | The number of ways to change amount a using n kinds of coins equals
;;     |  - the number of ways to change amount a using all but the first kind of coin, plus
;;     |  - the number of ways to change amount a−d using all n kinds of coins, where d is the
;;     |    denomination of the first kind of coin.
;;  At each step the procedure is oblivious to whether the previous denominations (d)
;;  were larger or smaller than the current one.