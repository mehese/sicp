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

(define (interleave s1 s2)
  (if (stream-null? s1)
      s2
      (cons-stream 
       (stream-car s1)
       (interleave s2 (stream-cdr s1)))))

(define (pairs s t)
  (cons-stream
   (list (stream-car s) (stream-car t))
   (interleave
    (stream-map (lambda (x) 
                  (list (stream-car s) x))
                (stream-cdr t))
    (pairs (stream-cdr s) (stream-cdr t)))))


;; Problem

(define int-pairs (pairs integers integers))

(define (count-pairs-before s target-pair)
  (define (found-pair? test-pair)
    (and (= (car target-pair) (car test-pair))
         (= (cadr target-pair) (cadr test-pair))))
  (define (iter-pairs substream count)
    (if (found-pair? (stream-car substream))
        count
        (begin
          ;(display (stream-car substream))
          (iter-pairs (stream-cdr substream) (inc count)))))
  (iter-pairs s 0))

;(count-pairs-before int-pairs (list   4  4))

;; Every second element is a (1 x) pair, but there's nothing that
;;  follows (1 1). Also we don't count the current pair. The formula
;;  for any (1 n) pair is 2n - 3
(count-pairs-before int-pairs (list   1 100)) ;; 197 as expected

;; n cnt
;; 1  0
;; 2  2
;; 3  6
;; 4  14
;; 5  30
;; 6  62
;; 7  126
;; 2(2^(n-1) - 1) for an (n n) pair
(count-pairs-before int-pairs (list 16 16)) ;; checks out
;(list 100 100)
;; 2(2^99 - 1) is way too big for my laptop
;;   ~ 1.267650600228229401496703205374 × 10^30

;; n cnt
;; 1 1 
;; 2 4   2x2
;; 3 10  2x5   3  ( 5- 2)
;; 4 22  2x11  6  (11- 5) 
;; 5 46  2x23  12 (12- 6)
;; 6 94  2x47  24 (24-12)
;; 7 190 2x95  48   ...
;; 8 382 2x191 96   ...
;; 9 766 2x383 192
;; 2*(3*2^(n-2) - 1) pairs that precede (n n+1 pair)
(count-pairs-before int-pairs (list 13 14)) ; 12286 as expected
;; again 2(3*2^97 - 1) too big to calculate in scheme for (99 100)
;;  is 950737950171172051122527404030
