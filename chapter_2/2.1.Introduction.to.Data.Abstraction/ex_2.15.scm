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

(define (print-comparison i1 i2)
  (display (par1 i1 i2))
  (display ", ")
  (display (par2 i1 i2))
  (newline))

(let
    ((A (make-center-percent  10  95.0))
     (B (make-center-percent   7  10.0))
     (C (make-center-percent 100   5.0))
     (D (make-center-percent   1   0.5))
     (E (make-center-percent  20   0.05))
     (almost-one (make-interval  0.990   1.0)))
  (display "0 width intervals") (newline)
  (print-comparison one one)
  (print-comparison (make-interval 50 50) one) ;; Note: all these would fail if we'd add the divide by 0 error
  (print-comparison (make-interval 50 50) (make-interval 50 50))
  (print-comparison (make-interval 20 20) (make-interval 20 20))
  (display "(approximately)1 and X") (newline)
  ;; When two resistances are placed in parallel, the resulting resistance
  ;;  is always lower than the smallest one of the two. Hence no resulting resistance
  ;;  should be higher than 1
  (print-comparison almost-one A)
  (print-comparison almost-one B)
  (print-comparison almost-one C)
  (print-comparison almost-one D)
  (print-comparison almost-one E)
  ;; Here par2 definitely behaves better

  (display "Intervals with small witdh") (newline)
  (print-comparison D D) ; an almost one, so the one closest to (0.5 . 0.5) wins
  (display "   ")
  (display (cons (center (par1 D D)) (center (par2 D D))))
  (newline)
  ;; par2 wins again

  (print-comparison E E) ; an almost (20 . 20), so the one closest to (10 . 10) wins
  (display "   ")
  (display (cons (center (par1 E E)) (center (par2 E E))))
  (newline)
  ;; par2 wins
)

;; The crux of the issue is that division is very poorly defined for intervals, i.e. X/X =/= [1,1]
;;  Divinding two width > 0 intervals introduces more uncertainty than dividing a width = 0 interval
;;  by a width =/= 0 interval. Hence the good money would be on par2, as it gives generally tighter
;;  bounds -- so Eva is right, each time when we minimize operations with uncertain intervals.