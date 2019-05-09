#lang sicp

(#%require (only racket/base random-seed))

;; Imports

(define (square x)
  (* x x))

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

(define (all lst)
  (if (null? lst)
      #t
      (and (car lst) (all (cdr lst)))))

(define (any-stream-null? . streams)
  (not (all (map (lambda (s) (not (stream-null? s)))
                 streams))))

(define (zip-streams . streams)
  (if (apply any-stream-null? streams)
      the-empty-stream
      (cons-stream
       (map stream-car streams)
       (apply zip-streams (map stream-cdr streams)))))

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

(define (list-to-stream lst)
  (if (null? lst)
      nil
      (cons-stream (car lst)
                   (list-to-stream (cdr lst)))))

(define (add-streams s1 s2) (stream-map + s1 s2))
(define (mul-streams s1 s2) (stream-map * s1 s2))

(define ones (cons-stream 1 ones))
(define integers (cons-stream 1 (add-streams ones integers)))

(define (rand-update k)
  (random-seed k)
  (random 100))

(define (random-in-range low high)
  (let ((range (- high low)))
    (+ low (random range))))


;; Problem

;; Force it to float
(define (div-streams s1 s2)
  (stream-map (lambda (a b) (* 1.0 (/ a b))) s1 s2))

(define (random-in-range-stream low high)
  (cons-stream
   (random-in-range low high)
   (random-in-range-stream low high)))


(define (estimate-integral P x1 x2 y1 y2 )
  (let*
      ((x-tries (random-in-range-stream x1 x2))
       (y-tries (random-in-range-stream y1 y2))
       (in-out-stream
        (stream-map (lambda (x y) (if (P x y) 1 0)) x-tries y-tries)))
    
    (define cumulative-hits
      (add-streams
       in-out-stream
       (cons-stream 0 cumulative-hits)))

    (list in-out-stream
          cumulative-hits
          (div-streams cumulative-hits integers))))
    

;; Circly stuff
(define (generate-circle x0 y0 r)
  (define (is-in-circle x y)
    (<= (+ (square (- x x0)) (square (- y y0)))
        (square r)))
  is-in-circle)

(define circle-predicate (generate-circle 5.0 7.0 3.0))

(define successive-approx
  (estimate-integral circle-predicate 2.0 8.0 4.0 10.0))

(define tries integers)
(define successes (car successive-approx))
(define total-successes (cadr successive-approx))
(define fraction-in (caddr successive-approx))
(define pi-approx (stream-map (lambda (f) (* 4 f)) fraction-in))

(stream-ref pi-approx 10000) ; mostly ≈ 3.14 ✔
