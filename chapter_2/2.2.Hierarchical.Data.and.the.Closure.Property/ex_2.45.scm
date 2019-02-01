#lang sicp

(#%require sicp-pict)

(define (corner-split painter n)
  (if (= n 0)
      painter
      (let ((up (up-split painter (- n 1)))
            (right (right-split painter 
                                (- n 1))))
        (let ((top-left (beside up up))
              (bottom-right (below right 
                                   right))
              (corner (corner-split painter 
                                    (- n 1))))
          (beside (below painter top-left)
                  (below bottom-right 
                         corner))))))

(define (square-limit painter n)
  (let ((quarter (corner-split painter n)))
    (let ((half (beside (flip-horiz quarter) 
                        quarter)))
      (below (flip-vert half) half))))

;; Implementation

(define (right-split-old painter n)
  (if (= n 0)
      painter
      (let ((smaller (right-split-old painter (- n 1))))
        (beside painter 
                (below smaller smaller)))))

(define (up-split-old painter n)
  (if (= n 0)
      painter
      (let ((smaller (up-split-old painter (- n 1))))
        (below painter 
                (beside smaller smaller)))))

(define (split where-one where-two)
  (define (split-procedure painter n)
    (if (= n 0)
        painter
        (let ((smaller (split-procedure painter (- n 1))))
          (where-one painter (where-two smaller smaller)))))
  
  split-procedure)

(display "right split reimplementation comparison") (newline)
(paint (right-split-old einstein 5))

(define right-split (split beside below))
(paint (right-split einstein 5)) ; ✔


(display "up split reimplementation comparison") (newline)
(paint (up-split-old einstein 5))

(define up-split (split below beside))
(paint (up-split einstein 5)) ; ✔