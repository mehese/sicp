#lang sicp

;; Imports
(define (stream-car stream) 
  (car stream))

(define (stream-cdr stream) 
  (force (cdr stream)))

(define (stream-map proc . argstreams)
  (if (stream-null? (car argstreams))
      the-empty-stream
      (cons-stream
       (apply proc (map stream-car argstreams))
       (apply stream-map 
              (cons proc 
                    (map stream-cdr 
                         argstreams))))))

(define (add-streams s1 s2) (stream-map + s1 s2))

;; Problem
(define s (cons-stream 1 (add-streams s s))) ;; pinky promise only ran this
                                             ;;  *after* writing response
;; Generates 1 2 4 8 16
;;  Equivalent to
;; (define double 
;;  (cons-stream 1 (scale-stream double 2)))
(define (display-first-n s n)
  (define (display-iter substream i)
    (if (> i n)
        (newline)
        (begin
          (display (stream-car substream))
          (newline)
          (display-iter (stream-cdr substream) (inc i)))))

  (display-iter s 0))