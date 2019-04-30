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

;; Problem
(define (div-series s1 s2)
  (let
      ((first-elem-denom (stream-car s2)))
    (if (= 0 first-elem-denom)
        (error "Cannot divide by series that starts with 0")
        (let
            ((scale-fact (/ 1.0 first-elem-denom)))

          (scale-stream
           (mul-series s1
                       (invert-unit-series
                        (scale-stream s2
                                      scale-fact)))
           scale-fact)))))

(define tan-series (div-series sine-series cosine-series))

(display-first-n tan-series 10)
;; First terms check out
;;0                   = a0  ✔
;;1.0                 = a1  ✔
;;0                   = a2  ✔
;;0.33333333333333337 = 1/3 = a3  ✔ 
;;0                   = a4  ✔
;;0.13333333333333336 = 2/15 = a5  ✔
;;0                   = a6  ✔
;;0.05396825396825397 = 17/315 = a7  ✔
;;0
;; https://www.quora.com/What-is-the-Taylor-series-for-tan-x