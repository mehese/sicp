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

(define (scale-stream stream factor)
  (stream-map
   (lambda (x) (* x factor))
   stream))

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

(define (display-first-n s n)
  (define (display-iter substream i)
    (if (> i n)
        (newline)
        (begin
          (newline)
          (display (stream-car substream)) (display " ")       
          (display-iter (stream-cdr substream) (inc i)))))

  (display-iter s 0))

(define (add-streams s1 s2) (stream-map + s1 s2))
(define (mul-streams s1 s2) (stream-map * s1 s2))

(define ones (cons-stream 1 ones))
(define integers (cons-stream 1 (add-streams ones integers)))

(define (integrate-series a-coeffs)
  (mul-streams
   a-coeffs
   (stream-map (lambda (x) (/ 1.0 x)) integers)))

(define exp-series
  (cons-stream 
   1 (integrate-series exp-series)))

(define (mul-series s1 s2)
  (cons-stream (* (stream-car s1) (stream-car s2))  
               (add-streams (scale-stream (stream-cdr s2) (stream-car s1))
                            (mul-series (stream-cdr s1) s2))))

(define (invert-unit-series S)
  (cons-stream 1
               (scale-stream
                (mul-series (stream-cdr S)
                            (invert-unit-series S))
                -1)))

(define (average x y) (/ (+ x y) 2.0))
(define (sqrt-improve guess x) (average guess (/ x guess)))

(define (sqrt-stream x)
  (define guesses
    (cons-stream 
     1.0 (stream-map
          (lambda (guess)
            (sqrt-improve guess x))
          guesses)))
  guesses)

;; Problem

(define (stream-limit stream tol)
  (define (progress-through-stream s prev-elem)
    (let
        ((curr-elem (stream-car s)))
      (if (<= (abs (- prev-elem curr-elem)) tol)
          curr-elem
          (progress-through-stream (stream-cdr s) curr-elem))))

  (progress-through-stream (stream-cdr stream) (stream-car stream)))

(define (sqrt x tolerance)
  (stream-limit (sqrt-stream x) tolerance))

(sqrt 2 1e-5); ✔
