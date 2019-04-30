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
(define (square x) (* x x))
(define (sqrt-improve guess x) (average guess (/ x guess)))

(define (sqrt-stream x)
  (define guesses
    (cons-stream 
     1.0 (stream-map
          (lambda (guess)
            (sqrt-improve guess x))
          guesses)))
  guesses)

(define (stream-limit stream tol)
  (define (progress-through-stream s prev-elem)
    (let
        ((curr-elem (stream-car s)))
      (if (<= (abs (- prev-elem curr-elem)) tol)
          curr-elem
          (progress-through-stream (stream-cdr s) curr-elem))))

  (progress-through-stream (stream-cdr stream) (stream-car stream)))

(define (partial-sums s1)
  (cons-stream (stream-car s1)
               (add-streams (stream-cdr s1) (partial-sums s1))))

(define (euler-transform s)
  (let ((s0 (stream-ref s 0))     ; Sₙ₋₁
        (s1 (stream-ref s 1))     ; Sₙ
        (s2 (stream-ref s 2)))    ; Sₙ₊₁
    (cons-stream 
     (- s2 (/ (square (- s2 s1))
              (+ s0 (* -2 s1) s2)))
     (euler-transform (stream-cdr s)))))

(define (make-tableau transform s)
  (cons-stream 
   s
   (make-tableau
    transform
    (transform s))))

(define (accelerated-sequence transform s)
  (stream-map stream-car
              (make-tableau transform s)))

;; Problem

(define ln2-series
  (stream-map (lambda (n)
                (* (/ 1.0 n) (expt -1 (- n 1)))) ;; (-1)^(n-1) * (1/n)
              integers))

;; ln2 = 0.693147180559945309417232121458176568075500134360255254120

;; 1. Vanilla approx
(define ln2-a
  (partial-sums ln2-series))

(display-first-n ln2-a 15)
;; after 15: elements still no 2 significant digits

;; 2. Euler technique
(newline)(display "-----------------------------")(newline)
(display-first-n
 (euler-transform ln2-a)
 15)
;; after 15: 4 significant digits

;; 3. Accelerated sequence technique
(newline)(display "-----------------------------")(newline)
(display-first-n
 (accelerated-sequence euler-transform
                       ln2-a)
 15) ;; starts spittings nans after the last digit is close to convergence
;; @ 10th iteration