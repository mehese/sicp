#lang sicp

;; Imports

(define pi 3.141592653589793)
(define square (lambda (x) (* x x)))

(define (make-from-real-imag x y)
  (define (dispatch op)
    (cond ((eq? op 'real-part) x)
          ((eq? op 'imag-part) y)
          ((eq? op 'magnitude)
           (sqrt (+ (square x) (square y))))
          ((eq? op 'angle) (atan y x))
          (else
           (error "Unknown op: 
            MAKE-FROM-REAL-IMAG" op))))
  dispatch)

(define (apply-generic op arg) (arg op))

;; Problem

(define (normalize-angle ang)
  (if (>= ang (* 2 pi))
      (normalize-angle (- ang (* 2 pi)))
      ang))

(define (make-from-mag-ang mag ang)
  (define (dispatch op)
    (cond ((eq? op 'real-part) (* mag (cos ang)))
          ((eq? op 'imag-part) (* mag (sin ang)))
          ((eq? op 'magnitude) mag)
          ((eq? op 'angle) (normalize-angle ang))
          (else
           (error "Unknown op: 
            MAKE-FROM-REAL-IMAG" op))))
  dispatch)


(let
    
    ((a-1 (make-from-real-imag 5 0))
     (a-2 (make-from-mag-ang 5 (* 2 pi))))

  (display "Real part") (newline)
  (display (apply-generic 'real-part a-1)) (newline)
  (display (apply-generic 'real-part a-2)) (newline); ✔ 

  (display "Imaginary part") (newline)
  (display (apply-generic 'imag-part a-1)) (newline)
  (display (apply-generic 'imag-part a-2)) (newline); ✔

  (display "Magnitude") (newline)
  (display (apply-generic 'magnitude a-1)) (newline)
  (display (apply-generic 'magnitude a-2)) (newline); ✔
  (display "Angle") (newline)
  (display (apply-generic 'angle a-1)) (newline)
  (display (apply-generic 'angle a-2)) (newline); ✔
  )

(newline)

(let
    
    ((a-1 (make-from-real-imag 1 1))
     (a-2 (make-from-mag-ang (* 1 (sqrt 2)) (/ pi 4.0))))

  (display "Real part") (newline)
  (display (apply-generic 'real-part a-1)) (newline)
  (display (apply-generic 'real-part a-2)) (newline); ✔ 

  (display "Imaginary part") (newline)
  (display (apply-generic 'imag-part a-1)) (newline)
  (display (apply-generic 'imag-part a-2)) (newline); ✔

  (display "Magnitude") (newline)
  (display (apply-generic 'magnitude a-1)) (newline)
  (display (apply-generic 'magnitude a-2)) (newline); ✔
  (display "Angle") (newline)
  (display (apply-generic 'angle a-1)) (newline)
  (display (apply-generic 'angle a-2)) (newline); ✔
  )

