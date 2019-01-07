#lang sicp

(define (cube x)
  (* x x x))

(define (sum-cubes a b)
  (if (> a b)
      0
      (+ (cube a) (sum-cubes (+ a 1) b))))

(cube 5)
(sum-cubes 5 9)