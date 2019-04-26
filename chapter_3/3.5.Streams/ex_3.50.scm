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

(define (stream-for-each proc s)
  (if (stream-null? s)
      'done
      (begin 
        (proc (stream-car s))
        (stream-for-each proc 
                         (stream-cdr s)))))


(define (display-stream s)
  (stream-for-each display-line s))

(define (display-line x)
  (newline)
  (display x))


;; Problem
(define (stream-map proc . argstreams)
  (if (stream-null? (car argstreams)) ;; if the first stream is null
      the-empty-stream                ;;  then return the null
      (cons-stream    ;; we're going to create a stream
       (apply proc (map stream-car argstreams)) ;; where we apply the function of all the parallel elements
       (apply stream-map ;; recurse on what's left
              (cons proc 
                    (map stream-cdr 
                         argstreams))))))


;; Test it out
(define (list-to-stream lst)
  (if (null? lst)
      nil
      (cons-stream (car lst)
                   (list-to-stream (cdr lst)))))

;; Examples from the footnote referenced
(define la (stream-map +
                       (list-to-stream '(  1   2   3))
                       (list-to-stream '( 40  50  60))
                       (list-to-stream '(700 800 900))))

(define lb (stream-map (lambda (x y) (+ x (* 2 y)))
                       (list-to-stream '(1 2 3))
                       (list-to-stream '(4 5 6))))

(display-stream la)
(display-stream lb)