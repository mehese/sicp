#lang sicp

(define (square n)
  (* n n))

(define (random-in-range low high)
  (let ((range (- high low)))
    (+ low (random range))))

(define (estimate-integral P x1 x2 y1 y2 n-trials)
  (let
      ((inside 0)
       (num-tries 0))
    (define (try)
      (if (= num-tries n-trials)
          (* 1.0 (/ inside num-tries))
          (begin
            (set! num-tries (inc num-tries))
            (let
                ((x (random-in-range x1 x2))
                 (y (random-in-range y1 y2)))
              (if (P x y)
                  (set! inside (inc inside))
                  #f))
            ;(display (list "num-tries" num-tries "inside" inside))
            ;(newline)
            (try))))
    (try)))

(define (generate-circle x0 y0 r)
  (define (is-in-circle x y)
    (<= (+ (square (- x x0)) (square (- y y0)))
        (square r)))
  is-in-circle)

(define circle-predicate (generate-circle 5.0 7.0 3.0))

(define f (estimate-integral circle-predicate 2.0 8.0 4.0 10.0 1000))

(display "Fraction in: ") (display f) (newline)
;; area ◯    πr^2    π
;; ------- = ----- = --- => π = 4*f 
;; area ▯     4r^2    4
(display "Approx pi: ") (display (* 4 f)); = 3.148  ✔