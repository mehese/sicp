#lang sicp

;; Imports
(define (stream-car stream) (car stream))

(define (stream-cdr stream) (force (cdr stream)))

(define (stream-ref s n)
  (if (= n 0)
      (stream-car s)
      (stream-ref (stream-cdr s) (- n 1))))

(define (stream-map proc s)
  (if (stream-null? s)
      the-empty-stream
      (cons-stream  (proc (stream-car s)) ;; This is the line that causes 0 to be
                                          ;; displayed by the definition of x
                    (stream-map proc (stream-cdr s)))))

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

(define (stream-enumerate-interval low high)
  (if (> low high)
      the-empty-stream
      (cons-stream
       low
       (stream-enumerate-interval (+ low 1) high))))

;;Problem
(define (show x)
  (display-line x)
  x)

(define x 
  (stream-map 
   show 
   (stream-enumerate-interval 0 10))) ;; Displays a 0 (the stream-car)
(newline)

(display "Result of (stream-ref x 5)") (newline)
(stream-ref x 5)
;; Displays
;;  1
;;  2
;;  3
;;  4
;;  5, returns 5
(newline)
(display "Result of (stream-ref x 7)") (newline)
(stream-ref x 7)
;; Displays
;;  6
;;  7, returns 7
;; Something underneath the hood something caches previous results -- most
;;  likely culprit being the (force ...) @ line 6
