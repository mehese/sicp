#lang sicp

;; Imports
(define (stream-car stream) 
  (car stream))

(define (stream-cdr stream) 
  (force (cdr stream)))

(define (stream-ref s n)
  (if (= n 0)
      (stream-car s)
      (stream-ref (stream-cdr s) (- n 1))))

(define (stream-map proc . argstreams)
  (if (stream-null? (car argstreams))
      the-empty-stream
      (cons-stream
       (apply proc (map stream-car argstreams))
       (apply stream-map 
              (cons proc 
                    (map stream-cdr 
                         argstreams))))))

(define (display-first-n s n)
  (define (display-iter substream i)
    (if (> i n)
        (newline)
        (begin
          (newline)
          (display (stream-car substream)) (display " ")       
          (display-iter (stream-cdr substream) (inc i)))))

  (display-iter s 0))

(define (scale-stream stream factor)
  (stream-map
   (lambda (x) (* x factor))
   stream))

(define (add-streams s1 s2) (stream-map + s1 s2))

(define ones (cons-stream 1 ones))
(define integers (cons-stream 1 (add-streams ones integers)))

;; Problem
(define (expand num den radix)
  (cons-stream
   (quotient (* num radix) den)
   (expand (remainder (* num radix) den) 
           den 
           radix)))

(display '(expand 1 7 10))
(display-first-n (expand 1 7 10) 10)
;; First 10 results 
;;   1 4 2 8 5 7 1 4 2 8 5 [expanding further yields more  1 4 2 8 5 7]
;;
;; observe that: 1.0/7 = 0.(142857) [in base 10]
(display '(expand 3 8 10))
(display-first-n (expand 3 8 10) 10)
;; First 10 results 
;;   3 7 5 0 0 0 0 0 0 0 0
;;
;; observe that: 3.0/8 = 0.375      [in base 10]

;; At each iteration we produce
;;             num *rad
;;  res = quot(--------)
;;                den
;;
;;  And then recurse with
;;             num *rad
;;  num <- rem(---------)
;;                den
;;  den <- den
;;  rad <- rad
;;
;; which is exactly what we do when we compute the division of two numbers

;; The procedure computes the decimal places of a division in the base radix