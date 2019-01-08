#lang sicp

;; Recursive version
(define (tan-cf x k)
  
  (define (n i)
    (if (= i 1)
        x
        (expt x 2)))
  
  ; 1, 3, 5, 7, 9 -> 2*(i-1) + 1
  (define (d i)
    (+ 1 (* 2 (- i 1))))
  
  (define (iter i)
    (if (> i k)
        0 ; reached the depth limit
        (/ (n i) (- (d i) (iter (+ i 1))))))  ; Ni/(Di + next fraction)
  (iter 1))

(tan-cf -2.0 10) ; -2.185039 ✓
(tan-cf -1.0 10) ; -1.557407 ✓
(tan-cf -0.5 10) ; -0.546302 ✓
(tan-cf  0.0 10) ;  0 ✓
(tan-cf  0.5 10) ;  0.546302 ✓
(tan-cf  1.0 10) ;  1.557407 ✓
(tan-cf  2.0 10) ;  2.185039 ✓
