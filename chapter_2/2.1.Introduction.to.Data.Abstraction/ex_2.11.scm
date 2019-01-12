#lang sicp

(define (make-interval a b) (cons a b))

(define (lower-bound interval)
  (car interval))

(define (upper-bound interval)
  (cdr interval))

(define (mul-interval x y)
  (let ((p1 (* (lower-bound x) 
               (lower-bound y)))
        (p2 (* (lower-bound x) 
               (upper-bound y)))
        (p3 (* (upper-bound x) 
               (lower-bound y)))
        (p4 (* (upper-bound x) 
               (upper-bound y))))
    (make-interval (min p1 p2 p3 p4)
                   (max p1 p2 p3 p4))))

;; One thing we know for sure
;;  Given an interval [a, b]
;;   a <= b
(define (mul-2 x y)
  (let
      ((a1 (lower-bound x))
       (b1 (upper-bound x))
       (a2 (lower-bound y))
       (b2 (upper-bound y)))
    (cond
      ((and (>= a1 0) (>= b1 0) (>= a2 0) (>= b2 0)) ;++++✔
       (make-interval
        (* a1 a2) ; a always <= b
        (* b1 b2))) ; b always >= a
      ((and (<  a1 0) (<  b1 0) (<  a2 0) (<  b2 0)) ;----✔
       (make-interval ; abs(b) < abs(a), so swap the above
        (* b1 b2) 
        (* a1 a2))) 
      ((and (>= a1 0) (>= b1 0) (<  a2 0) (>= b2 0)) ;++-+✔
       (make-interval
        (* b1 a2)
        (* b1 b2)))
      ((and (<  a1 0) (>= b1 0) (<  a2 0) (<  b2 0)) ;-+--✔
       (make-interval
        (* b1 a2) ; (-) & abs(a2) > abs(b2))
        (* a1 a2))) ; (-)*(-)=(+) & abs(a2) > abs(b2) 
      ((and (<  a1 0) (>= b1 0) (>= a2 0) (>= b2 0)) ;-+++✔
       (make-interval
        (* a1 b2) ; (-) * max(a2,b2)
        (* b1 b2)))           
      ((and (<  a1 0) (<  b1 0) (>= a2 0) (>= b2 0)) ;--++✔
       (make-interval ; can't avoid (-) sign, so maximise abs for min, and min for max
        (* a1 b2) ;  
        (* b1 a2))) ;      
      ((and (<  a1 0) (<  b1 0) (<  a2 0) (>= b2 0)) ;---+✔
       (make-interval
        (* a1 b2) ; abs(a1)>abs(b1) and we want the sign to be (-)
        (* a1 a2))) ; abs(a1)>abs(b1) and we want the sign to be (+)  
      ((and (>= a1 0) (>= b1 0) (<  a2 0) (>= b2 0)) ;++-+✔
       (make-interval
        (* b1 a2)
        (* b1 b2)))      
      ((and (>= a1 0) (>= b1 0) (<  a2 0) (<  b2 0)) ;++--✔
       (make-interval
        (* a2 b1) ; abs(a2) > abs(b2)
        (* a1 b2))) ; abs(b2) < abs(a2) -> we need to multiply the smalles absolute values
      (else ;  ;-+-+✔
       (make-interval
        (min (* a1 b2) (* b1 a2)) ; sign needs to be (-)
        (max (* a1 a2) (* b1 b2))))))) ; sign needs to be (+)

(display "Old multiplication")
(newline)
(let
    ((i1 (make-interval  0 5))
     (i2 (make-interval -2 3))
     (i3 (make-interval -4 -2))
     (i4 (make-interval -3 1))
     (i5 (make-interval  1 5)))
  (display "1 ++++")
  (display (mul-interval i5 i5))
  (newline)
  (display "2 ----")
  (display (mul-interval i3 i3))
  (newline)
  (display "3 -+--")
  (display (mul-interval i2 i3))
  (newline)
  (display "4 -+++")
  (display (mul-interval i2 i5))
  (newline)
  (display "5 -+-+")
  (display (mul-interval i2 i4))
  (newline)
  (display "6 --++")
  (display (mul-interval i3 i5))
  (newline)
  (display "7 ---+")
  (display (mul-interval i3 i4))
  (newline)
  (display "8 ++-+")
  (display (mul-interval i5 i4))
  (newline)
  (display "9 ++--")
  (display (mul-interval i5 i3))
  (newline))

(display "New multiplication")
(newline)
(let
    ((i1 (make-interval  0 5))
     (i2 (make-interval -2 3))
     (i3 (make-interval -4 -2))
     (i4 (make-interval -3 1))
     (i5 (make-interval  1 5)))
  (display "1 ++++")
  (display (mul-2 i5 i5))
  (newline)
  (display "2 ----")
  (display (mul-2 i3 i3))
  (newline)
  (display "3 -+--")
  (display (mul-2 i2 i3))
  (newline)
  (display "4 -+++")
  (display (mul-2 i2 i5))
  (newline)
  (display "5 -+-+")
  (display (mul-2 i2 i4))
  (newline)
  (display "6 --++")
  (display (mul-2 i3 i5))
  (newline)
  (display "7 ---+")
  (display (mul-2 i3 i4))
  (newline)
  (display "8 ++-+")
  (display (mul-2 i5 i4))
  (newline)
  (display "9 ++--")
  (display (mul-2 i5 i3))
  (newline))
