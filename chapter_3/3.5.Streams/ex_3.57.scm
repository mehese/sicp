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
          (display (stream-car substream))       
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
(define fibs
  (cons-stream
   0 (cons-stream
      1 (add-streams
         fibs
         (stream-cdr fibs)))))

(display-first-n fibs 20)

;; Memoized approach
;;   n additions, as we compute one sum  @ each n
;;
;; Non memoized approach
;;   at each step n we need to recompute the additions of step n-1 & n-2
;;   and add them. This would have the same growth rate as the Fibonacci
;;   series itself, which is exponential ~ φⁿ