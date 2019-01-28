#lang sicp

(define (accumulate op initial sequence)
  (if (null? sequence)
      initial
      (op (car sequence)
          (accumulate op 
                      initial 
                      (cdr sequence)))))

(define (accumulate-n op init seqs)
  (if (null? (car seqs))
      nil
      (cons (accumulate op init (map car seqs))
            (accumulate-n op init (map cdr seqs)))))

(define eye
  (list (list 1 0 0 0)
        (list 0 1 0 0)
        (list 0 0 1 0)
        (list 0 0 0 1)))

(define m1
  (list (list 1 2 3 4)
        (list 4 5 6 6)
        (list 6 7 8 9)))

(display "Verify dot product") (newline)
(define (dot-product v w)
  (accumulate + 0 (map * v w)))

(dot-product (list 1 2 3 4) (list 0 1 0 1)) ; ✔ 

(display "Verify matrix vector multiplication") (newline)
(define (matrix-*-vector m v)
  (map
   (lambda (w) (dot-product v w))
   m))

(matrix-*-vector eye (list 5 5 5 5)) ; ✔ 
(matrix-*-vector m1 (list 1 0 0)) ; ✔ 

(display "Verify matrix transpose") (newline)
(define (transpose mat)
  (accumulate-n
   cons ; op
   nil ; init
   mat))

(transpose eye) ; ✔ 
(transpose m1) ; ✔ 

(display "Verify matrix multiplication") (newline)
(define (matrix-*-matrix m n)
  (let ((cols (transpose n)))
    (map
     (lambda (vec) (matrix-*-vector cols vec))
     m)))


(matrix-*-matrix m1 eye) ; ✔ 
(matrix-*-matrix (list (list 1 0 0)
                       (list 0 1 0)
                       (list 0 0 1)) m1) ; ✔ 
(matrix-*-matrix m1 (transpose m1)) ; = [[ 30,  56,  80],
                                    ;    [ 56, 113, 161],
                                    ;    [ 80, 161, 230]] ✔ 