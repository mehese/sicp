#lang sicp

;; Imports
(define (stream-car stream) (car stream))

(define (stream-cdr stream) (force (cdr stream)))

(define (stream-ref s n)
  (if (= n 0)
      (stream-car s)
      (stream-ref (stream-cdr s) (- n 1))))

(define (stream-map proc s)
  (if (stream-null? s)
      the-empty-stream
      (cons-stream  (proc (stream-car s)) ;; This is the line that causes 0 to be
                                          ;; displayed by the definition of x
                    (stream-map proc (stream-cdr s)))))

(define (stream-filter pred stream)
  (cond ((stream-null? stream) 
         the-empty-stream)
        ((pred (stream-car stream))
         (cons-stream  (stream-car stream)
                       (stream-filter pred (stream-cdr stream))))
        (else (stream-filter pred (stream-cdr stream)))))

(define (stream-for-each proc s)
  (if (stream-null? s)
      'done
      (begin 
        (proc (stream-car s))
        (stream-for-each proc (stream-cdr s)))))

(define (display-stream s)
  (stream-for-each display-line s))

(define (display-line x)
  (newline) (display x))

(define (stream-enumerate-interval low high)
  (if (> low high)
      the-empty-stream
      (cons-stream
       low
       (stream-enumerate-interval (+ low 1) high))))

;;Problem
(define sum 0)
;; Keeping an eye of sum will let us know how many elements
;;  of seq needed to be computed


(define (accum x)
  (set! sum (+ x sum))
  sum)
;; Value of sum is 0

(define seq ;; the cumsum of integers 1-20
  (stream-map 
   accum 
   (stream-enumerate-interval 1 20)))
;; Value of sum is 1, as the car of the list needed to be computed

(define y (stream-filter even? seq))
;; Value of sum is 6, as only the 3rd element of the list is even

(define z 
  (stream-filter 
   (lambda (x) 
     (= (remainder x 5) 0)) seq))
;; Value of sum is 10
;; elems computed: 1, 3, 6, 10

(display "(stream-ref y 7)")
(stream-ref y 7)
;; Nothing called via display, function returns 136
;; Value of sum is 136
;; elems computed:
;;  1,3,6,10,15,21,28,36,45,55,66,78,91,105,120,136
(display "(display-stream z)")
(display-stream z)
;;10
;;15
;;45
;;55
;;105
;;120
;;190
;;210, returns 'done
;; Value of sum is 210

;; Without the memoized delay the values would need to be recomputed
;;  again. BUT accum accumulates state, so every time we would recompute
;;  seq the values would change!!