#lang sicp

(define (make-interval a b) (cons a b))

(define (lower-bound interval)
  (car interval))

(define (upper-bound interval)
  (cdr interval))

(define (add-interval x y)
  (make-interval (+ (lower-bound x) 
                    (lower-bound y))
                 (+ (upper-bound x) 
                    (upper-bound y))))

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

(define (div-interval x y)
  (mul-interval x 
                (make-interval 
                 (/ 1.0 (upper-bound y)) 
                 (/ 1.0 (lower-bound y)))))

(define (sub-interval x y)
  (add-interval x
                (make-interval
                 (- (upper-bound y))
                 (- (lower-bound y)))))

(define (width interval)
  (/ (- (upper-bound interval) (lower-bound interval)) 2))

(define (make-center-width c w)
  (make-interval (- c w) (+ c w)))

(define (center i)
  (/ (+ (lower-bound i) (upper-bound i)) 2))

(define (percent i)
  (* 100 (/ (width i) (center i))))

(define (make-center-percent c tol)
  (let
      ((w (/ (* tol c) 100)))
    (make-center-width c w)))

(define (tol i)
  (let
      ((c (center i))
       (l (lower-bound i))
       (h (upper-bound i)))
    (* (/ (abs (- c l)) c) 100.0)))

(define (par1 r1 r2)
  (div-interval 
   (mul-interval r1 r2)
   (add-interval r1 r2)))

(define (par2 r1 r2)
  (let ((one (make-interval 1 1)))
    (div-interval 
     one
     (add-interval 
      (div-interval one r1) 
      (div-interval one r2)))))

;; Helper functions

(define (cpc-form i)
  (cons (center i) (percent i)))

(define one (make-interval 1 1))

(define (one-over-i-times-i i)
  ;; Ideally would return one
  (mul-interval (div-interval one i) i))

(let
    ((A (make-center-percent  10  50.0))
     (B (make-center-percent   7  10.0))
     (C (make-center-percent 100   5.0))
     (D (make-center-percent   1   0.5))
     (E (make-center-percent  20   0.05))
     )

  ;; Sanity Check
  (display "1*X should equal X") (newline)
  (display A) (display ", ") (display (mul-interval one A))
  (newline)
  (display B) (display ", ") (display (mul-interval one B))
  (newline)
  (display C) (display ", ") (display (mul-interval one C))
  (newline)
  (display D) (display ", ") (display (mul-interval one D))
  (newline)
  (display E) (display ", ") (display (mul-interval one E))
  (newline)
  (newline)
  ;; i/i should equal 1
  (display "(X/X) should equal 1") (newline)
  (display (div-interval A A))
  (display ", aka ")
  (display (cpc-form (div-interval A A)))  ;; center off by 66%, width 80% instead of 0 (~ 1.6x %width A)
  (newline)
  (display (div-interval B B))
  (display ", aka ")
  (display (cpc-form (div-interval B B))) ;; center off by 2%, width 20% instead of 0 (~ 2x %width B)
  (newline)
  (display (div-interval C C))
  (display ", aka ")
  (display (cpc-form (div-interval C C))) ;; center off by 0.5%, width 10% instead of 0 (~ 2x %width C)
  (newline)
  (display (div-interval D D))
  (display ", aka ")
  (display (cpc-form (div-interval D D))) ;; center off by 0.005%, width 1% instead of 0 (~ 2x %width D)
  (newline)
  (display (div-interval E E))
  (display ", aka ")
  (display (cpc-form (div-interval E E))) ;; center almost good, width 0.1% instead of 0 (~ 2x %width E)
  (newline)
  (newline)
  ;; (1/i)*i should equal 1
  (display "(X*1/X) should equal 1") (newline)
  (display (one-over-i-times-i A))
  (display ", aka ")
  (display (cpc-form (one-over-i-times-i A))) ;; center off by 66%, width 80% instead of 0 (~ 1.6x %width A)
  (newline)
  (display (one-over-i-times-i B))
  (display ", aka ")
  (display (cpc-form (one-over-i-times-i B))) ;; center off by 2%, width 20% instead of 0 (~ 2x %width B)
  (newline)
  (display (one-over-i-times-i C))
  (display ", aka ")
  (display (cpc-form (one-over-i-times-i C))) ;; center off by 0.5%, width 10% instead of 0 (~ 2x %width C)
  (newline)
  (display (one-over-i-times-i D))
  (display ", aka ")
  (display (cpc-form (one-over-i-times-i D))) ;; center off by 0.005%, width 1% instead of 0 (~ 2x %width D)
  (newline)
  (display (one-over-i-times-i E))
  (display ", aka ")
  (display (cpc-form (one-over-i-times-i E)));; center almost good, width 0.1% instead of 0 (~ 2x %width E)
  (newline)
  (newline)
  )

;; For large percentage changes, X*1/X doesn't return 1, even for small percentage changes we don't obtain
;;  0 for the width

;; Let's test out the different results returned by the two formulae

(define (print-comparison i1 i2)
  (display (par1 i1 i2))
  (display ", ")
  (display (par2 i1 i2))
  (newline))

(let
    ((A (make-center-percent  10  50.0))
     (B (make-center-percent   7  10.0))
     (C (make-center-percent 100   5.0))
     (D (make-center-percent   1   0.5))
     (E (make-center-percent  20   0.05)))
  (display "                par1 vs par2") (newline)
  (print-comparison A A)
  (print-comparison A B)
  (print-comparison B A) 
  (print-comparison D E) 
  (print-comparison E D) 
  (print-comparison E E) 
) ;; At least both versions are commutative, but the differences are huge!