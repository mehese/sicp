#lang sicp

;; Imports
(define (square x) (* x x))

(define (sum-squares . args)
  (apply + (map square args)))

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

(define (weighted-pairs s t w-fun)
  (cons-stream
   (list (stream-car s) (stream-car t))
   (merge-weighed
    (stream-map (lambda (elem)
                 (list (stream-car s) elem))
                (stream-cdr t))
    (weighted-pairs (stream-cdr s) (stream-cdr t) w-fun)
    w-fun)))


;; Problem
(define sq-pairs
  (weighted-pairs integers integers sum-squares))

(define (find-sum-sq s)
  (let*
      ((a (stream-car s))
       (b (stream-car (stream-cdr s)))
       (c (stream-car (stream-cdr (stream-cdr s))))
       (a-sq (apply sum-squares a))
       (b-sq (apply sum-squares b))
       (c-sq (apply sum-squares c)))

    (if (= a-sq b-sq c-sq)
        (list (stream-cdr s) a b c a-sq)
        (find-sum-sq (stream-cdr s)))))

(define (gen-nice-nums pair-stream)
  (let*
      ((res (find-sum-sq pair-stream))
       (rest-stream (car res))
       (head (cdr res)))
    (cons-stream
     head
     (gen-nice-nums rest-stream))))

(define nice-nums (gen-nice-nums sq-pairs))

(display-first-n nice-nums 10); ✔ 
    


    