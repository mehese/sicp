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

(define (merge-weighed s1 s2 w-fun)
  (cond ((stream-null? s1) s2)
        ((stream-null? s2) s1)
        (else
         (let ((s1car (stream-car s1))
               (s2car (stream-car s2)))
           (cond ((<= (apply w-fun s1car) (apply w-fun s2car))
                  (cons-stream 
                   s1car 
                   (merge-weighed (stream-cdr s1) 
                          s2 w-fun)))
                 ((> (apply w-fun s1car) (apply w-fun s2car))
                  (cons-stream 
                   s2car 
                   (merge-weighed s1 
                          (stream-cdr s2) w-fun)))
                 (else
                  (error "Error: dunno what to do with" (list s1car s2car))))))))

(define (integral integrand initial-value dt)
  (define int
    (cons-stream 
     initial-value
     (add-streams (scale-stream integrand dt)
                  int)))
  int)

(define sense-data (stream-map sin (scale-stream integers (/ 1 3))))

(define (sign-change-detector a b)
  (cond
    ((and (>= a 0) (>= b 0))  0)
    ((and (<  a 0) (<  b 0))  0)
    ((and (>= a 0) (<  b 0))  1)
    ((and (<  a 0) (>= b 0)) -1)
    (else (error "WTF"))))

(define (make-zero-crossings-old 
         input-stream last-value last-avg)
  (let ((avpt
         (/ (+ (stream-car input-stream) 
               last-value) 
            2)))
    (cons-stream
     (sign-change-detector avpt last-avg)
     (make-zero-crossings-old 
      (stream-cdr input-stream) (stream-car input-stream) avpt))))

(define zero-crossings-old 
  (make-zero-crossings-old sense-data 0 0))

;; Problem
(define (smooth s)
  (let
      ((current-value (stream-car s))
       (next-value (stream-car (stream-cdr s))))
    (cons-stream
     (/ (+ current-value next-value) 2)
     (smooth (stream-cdr s)))))

(define (make-zero-crossings input-stream signal-processing-fun)
  (define (make-zero-crossings-inner
           s last-value)
    (cons-stream
     (sign-change-detector 
      (stream-car s) 
      last-value)
     (make-zero-crossings-inner 
      (stream-cdr s)
      (stream-car s))))
  (make-zero-crossings-inner
   (cons-stream 0 (signal-processing-fun input-stream))
   0))

(define zero-crossings 
  (make-zero-crossings sense-data smooth))

(display-first-n (zip-streams sense-data zero-crossings-old zero-crossings)
                 50); ✔ 