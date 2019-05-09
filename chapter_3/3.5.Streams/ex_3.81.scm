#lang sicp

(#%require (only racket/base random-seed))

;; Imports
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


;; Problem

(define (random-stream seed)
  (let
      ((current-val (rand-update seed)))
    (cons-stream
     current-val
     (random-stream current-val))))

(define (random-stream-maker s seed-val)
    (cond
      ((stream-null? s)
       the-empty-stream)
      ((eq? (stream-car s) 'generate)
       (let
           ((current-val (rand-update seed-val)))
         (cons-stream
          current-val
          (random-stream-maker (stream-cdr s) current-val))))
      ((and (pair? (stream-car s)) (eq? 'reset (car (stream-car s))))
       (let
           ((new-seed (cadr (stream-car s))))
         (cons-stream
          new-seed
          (random-stream-maker (stream-cdr s) new-seed))))))
     
  

(define instruction-stream (list-to-stream '((reset 5)
                                             generate
                                             generate
                                             generate
                                             (reset 5)
                                             generate
                                             generate
                                             (reset 7)
                                             generate
                                             generate
                                             generate
                                             generate)))
(define different-instruction-stream
  (list-to-stream'((reset 2)
                   generate
                   generate
                   generate
                   generate
                   generate
                   generate
                   (reset 7)
                   generate
                   generate
                   generate
                   generate)))

(define r1 (random-stream-maker instruction-stream 0))
(define r2 (random-stream-maker instruction-stream 0))
(define r3 (random-stream-maker different-instruction-stream 0))

(display-stream (zip-streams r1 r2 r3)); ✔
