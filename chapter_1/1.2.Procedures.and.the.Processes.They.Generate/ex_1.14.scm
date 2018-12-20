#lang sicp

(define (count-change amount)
  (cc amount 5))

(define (cc amount kinds-of-coins)
  (cond ((= amount 0) 1)
        ((< amount 0) 0) 
        ((= kinds-of-coins 0)0)
        (else 
         (+ (cc amount (- kinds-of-coins 1))
            (cc (- amount (first-denomination 
                           kinds-of-coins))
                kinds-of-coins)))))

(define (first-denomination kinds-of-coins)
  (cond ((= kinds-of-coins 1) 1)
        ((= kinds-of-coins 2) 5)
        ((= kinds-of-coins 3) 10)
        ((= kinds-of-coins 4) 25)
        ((= kinds-of-coins 5) 50)))

(count-change 11)

;; see figure ex_1.14.png for recursive call

;; To calculate the space complexity we must determine the depth of the
;;  call stack. In the figure the max depth is 11 -- that is equal to the
;;  amount passed to the function. However if the minimum denomination would
;;  be higher, the stack depth would be smaller since we would decrement by
;;  a higher amount. So the space requirement is O(n) where n = amount/min_denom
;;  but min_denom is a constant so, the space requirement is O(amount)

;; The time complexity is a bit trickier, the answer is O(n^k). The best written
;;  argument I found is here. The induction goes like this
;;    for cc(n, 1) the order is O(n) as we make 2*n/denom_1 calls
;;    for cc(n, 2) we have n/denom_2 calls to cc(n, 1) => O(n^2)
;;    for cc(n, 3) we have n/denom_3 calls to cc(n, 2) => O(n^3)
;;    ...
;;    for cc(n, k-1) we will have n/denom_k-1 calls to cc(n, k-2) => O(n^k-1)
;;    for cc(n, k) we will have n/denom_k calls to cc(n, k-1) => O(n^k)

;; http://www.billthelizard.com/2009/12/sicp-exercise-114-counting-change.html
;; https://cs.stackexchange.com/questions/7105/time-complexity-for-count-change-procedure-in-sicp
;; http://www.ysagade.nl/2015/04/12/sicp-change-growth/