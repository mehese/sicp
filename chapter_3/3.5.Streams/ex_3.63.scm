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

;; Old sqrt-stream
;(define (sqrt-stream x)
;  (define guesses
;    (cons-stream 
;     1.0 (stream-map
;          (lambda (guess)
;            (sqrt-improve guess x))
;          guesses)))
;  guesses)


;; Problem

(define (sqrt-stream x)
  (cons-stream 
   1.0
   (stream-map (lambda (guess)
                 (sqrt-improve guess x))
               (sqrt-stream x)))) ;; every time this function is called
                                  ;; a new stream needs gets created, so
                                  ;; at each step all the steps leading up
                                  ;; to it are recomputed -> O(N^2)

(display-first-n (sqrt-stream 2) 10)
;; In the previous implementation definining that local variable means
;;  that all the delayed calls are memoized -> O(N) running time

;; If delay was not memoized the old implementation and the new one would
;;  have the same running time