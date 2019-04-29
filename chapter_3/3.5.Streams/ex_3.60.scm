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


(define cosine-series 
  (cons-stream 1 (scale-stream (integrate-series sine-series) -1)))

(define sine-series
  (cons-stream 0 (integrate-series cosine-series)))

;; Problem

;; s1 * s2
;; (a0 + a1x + a2x^2 + a3x^3 + ...)*(b0 + b1x + b2x^2 + b3x^3 + ...)
;;  a0b0 + a0*[rest-s2] +s2*[rest-s1] 

(define (mul-series s1 s2)
  (cons-stream (* (stream-car s1) (stream-car s2))  ;; a0b0
               (add-streams (scale-stream (stream-cdr s2) (stream-car s1)) ;; a0*[rest-b]
                            (mul-series (stream-cdr s1) s2)))) ;; [rest-a]*b

(define sine-sq (mul-series sine-series sine-series))

(define cosine-sq (mul-series cosine-series cosine-series))

(define (sum-first-n series n)
  (define (sum-iter subseries i acc)
    (if (>= i n)
        acc
        (sum-iter (stream-cdr subseries)
                  (+ i 1)
                  (+ acc (stream-car subseries)))))
  (sum-iter series 0 0))

(sum-first-n (add-streams sine-sq cosine-sq) 10) ; = 1.0 ✔
(sum-first-n (add-streams sine-sq cosine-sq) 100) ; = 1.0 ✔
(sum-first-n (add-streams sine-sq cosine-sq) 1000) ; = 1.0 ✔
  