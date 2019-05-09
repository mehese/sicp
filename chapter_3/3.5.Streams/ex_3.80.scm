#lang racket

;; Imports
;; SICP language is not being friendly with variable declarations, so this
;;  is a workardound from https://stackoverflow.com/a/13999010
(define-syntax cons-stream
  (syntax-rules ()
    ((cons-stream head tail)
     (cons head (delay tail)))))

(define the-empty-stream '())

(define (stream-car stream) 
  (car stream))

(define (stream-null? stream)
  (null? stream))


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

(define (zip-streams . streams)
  (cons-stream
   (map stream-car streams)
   (apply zip-streams (map stream-cdr streams))))

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

(define (stream-filter pred stream)
  (cond ((stream-null? stream) 
         the-empty-stream)
        ((pred (stream-car stream))
         (cons-stream 
          (stream-car stream)
          (stream-filter 
           pred
           (stream-cdr stream))))
        (else (stream-filter 
               pred 
               (stream-cdr stream)))))

(define (display-stream s)
  (stream-for-each display-line s))

(define (display-line x)
  (newline) (display x))

(define (display-first-n s n)
  (define (display-iter substream i)
    (if (>= i n)
        (newline)
        (begin
          (newline)
          (display (stream-car substream)) (display " ")       
          (display-iter (stream-cdr substream) (+ i 1)))))

  (display-iter s 0))

(define (add-streams s1 s2) (stream-map + s1 s2))
(define (mul-streams s1 s2) (stream-map * s1 s2))

(define ones (cons-stream 1 ones))
(define integers (cons-stream 1 (add-streams ones integers)))

(define (integral
         delayed-integrand initial-value dt)
  (define int
    (cons-stream 
     initial-value
     (let ((integrand 
            (force delayed-integrand)))
       (add-streams 
        (scale-stream integrand dt)
        int))))
  int)

(define (solve f y0 dt)
  (define y (integral (delay dy) y0 dt))
  (define dy (stream-map f y))
  y)

;; Problem

(define (RLC R L C dt)
  (lambda (iL0 vC0) ;; In a manner similar [...] should produce a procedure
    (define iL (integral
              (delay diL)
              iL0
              dt))
     (define vC (integral
              (delay dvC)
              vC0
              dt))
     (define dvC (scale-stream iL (/ -1 C)))
     (define diL (add-streams
               (scale-stream vC (/ 1 L))
               (scale-stream iL (/ (- R) L))))
     (cons iL vC)))

(define res-streams ((RLC 1    ; R = 1 ohm
                          1    ; L = 1 H
                          0.2  ; C = 0.2 F
                          0.1) ; dt = 0.1 s
                         0     ; iL0 = 0 A
                         10))  ; vC0 = 10 V

(define iL (car res-streams))
(define vC (cdr res-streams))

(display-first-n (zip-streams iL vC) 200)