#lang sicp

(define (make-point x y)
  (cons x y))

(define (x-point p)
  (car p))

(define (y-point p)
  (cdr p))

(define (make-rectangle p1 p2)
  (cons p1 p2))

(define (make-other-rectangle origin width height)
  (cons origin (cons width height)))


;; Height and witdth abstract the perimeter away
(define (width rectangle)
  (let
      ((p1 (car rectangle))
       (p2 (cdr rectangle)))
       (- (x-point p2) (x-point p1))))

(define (height rectangle)
  (let
      ((p1 (car rectangle))
       (p2 (cdr rectangle)))
       (- (y-point p2) (y-point p1))))


(define (print-point p)
  (newline)
  (display "(")
  (display (x-point p))
  (display ",")
  (display (y-point p))
  (display ")"))

(display "First implementation")
(newline)
(let
    ((r (make-rectangle
         (make-point -1.0 -1.0)
         (make-point 2.0 4.0))))

  (define (area rectangle) ; Same area definition as below
    (* (width rectangle) (height rectangle)))

  (define (perimeter rectangle) ; Same perimeter definition as below
    (+ (* 2 (width rectangle)) (* 2 (height rectangle))))
  (display "w: ")
  (display (width r))
  (newline)
  (display "h: ")
  (display (height r))
  (newline)
  (display "Area: ")
  (display (area r))
  (newline)
  (display "Perimeter: ")
  (display (perimeter r))
  (newline))

(newline)
(display "Second implementation")
(newline)
(let 
    ((r (make-other-rectangle (make-point -1.0 -1.0) 3 5))
     (width (lambda (rect) (car (cdr rect)))) ; Need to redefine height and width for the new rectangle
     (height (lambda (rect) (cdr (cdr rect)))))

  (define (area rectangle) ; Same area definition as above
    (* (width rectangle) (height rectangle)))

  (define (perimeter rectangle) ; Same perimeter definition as above
    (+ (* 2 (width rectangle)) (* 2 (height rectangle))))
  
  (display "w: ")
  (display (width r))
  (newline)
  (display "h: ")
  (display (height r))
  (newline)
  (display "Area: ")
  (display (area r))
  (newline)
  (display "Perimeter: ")
  (display (perimeter r))
  (newline))
