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
          (display (stream-car substream))
          (newline)
          (display-iter (stream-cdr substream) (inc i)))))

  (display-iter s 0))

(define (add-streams s1 s2) (stream-map + s1 s2))

(define ones (cons-stream 1 ones))
(define integers (cons-stream 1 (add-streams ones integers)))

;; Problem
(define partials 
  (cons-stream 1 (add-streams (stream-cdr integers) partials)))

(define (partial-sums s1)
  (cons-stream (stream-car s1)
               (add-streams (stream-cdr s1) (partial-sums s1))))



(display-first-n (partial-sums integers) 4)
(display-first-n (partial-sums ones) 10)