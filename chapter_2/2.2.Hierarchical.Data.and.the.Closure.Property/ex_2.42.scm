#lang sicp

;; Imports
(define (filter predicate sequence)
  (cond ((null? sequence) nil)
        ((predicate (car sequence))
         (cons (car sequence)
               (filter predicate 
                       (cdr sequence))))
        (else  (filter predicate 
                       (cdr sequence)))))

(define (accumulate op initial sequence)
  (if (null? sequence)
      initial
      (op (car sequence)
          (accumulate op 
                      initial 
                      (cdr sequence)))))

(define (flatmap proc seq)
  (accumulate append nil (map proc seq)))

(define (enumerate-interval low high)
  (if (> low high)
      nil
      (cons low 
            (enumerate-interval 
             (+ low 1) 
             high))))

(define (accumulate-n op init seqs)
  (if (null? (car seqs))
      nil
      (cons (accumulate op init (map car seqs)) ; sum over first element of provided lists
            (accumulate-n op init (map cdr seqs)))))

;; Implementation

;; This is a pretty nasty function, but we realize it generates k^k elements which is exactly
;; how many possible positions we would get by moving each queen on its column
(define (queens board-size)
  (define (queen-cols k)
    (if (= k 0)
        (list empty-board)
        (filter ;; keep only the safe positions
         (lambda (positions) (safe? k positions))
         (flatmap ;; place the queen on each row
          (lambda (rest-of-queens)
            (map (lambda (new-row)
                   (adjoin-position new-row k rest-of-queens))
                 (enumerate-interval 1 board-size)))
          (queen-cols (- k 1))))))
  (queen-cols board-size))


(define empty-board nil)

; all function that can be applied to list
(define (all lst) (accumulate (lambda (a b) (and a b)) #t lst))
; any function that can be applied to list
(define (any lst) (accumulate (lambda (a b) (or a b)) #f lst))


;; Function that checks whether two queens are on the same row
(define (same-row pos1 pos2) (= (get-row pos1) (get-row pos2)))

;; Checks if there's any position in a list of positions that is on the same row with the current queen
(define (any-on-same-row position-to-check positions-of-others)
  (any
   (map (lambda (position) (same-row position-to-check position))
        positions-of-others)))

(define (attacks-diagonally queen-low queen-high)
  (cond ((>= (get-column queen-low) (get-column queen-high))
         ;; Code would work without this error, but throwing errors makes me feel safe
         (error "queen high should always be placed on a higher column")))
   ;; Attacks diagonally if abs(Q2.i - Q1.i) == (Q2.j - Q1.j)
   (=
    (abs (- (get-row queen-high) (get-row queen-low)))
    (- (get-column queen-high) (get-column queen-low))))

;; Checks if there's any position in a list of positions that attacks diagonally the current queen
(define (any-attacks-diagonally position-to-check positions-of-others)
  (any (map (lambda (position) (attacks-diagonally position position-to-check))
            positions-of-others)))

(define (safe? k positions)
  (cond
    ((null? (cdr positions)) #t) ; a lonely queen on a 1 square board is safe ❤
    (else (let
              ((this-elem (car positions)) ; Assumes first element is always on row k
               (other-positions (cdr positions)))

            ;; All of the following conditions need to be met
            (and
             ;; No position must be on the same row with the position we're checking
             (not (any-on-same-row this-elem other-positions))

             ;; No position must be on the same column with the position we're checking
             #t ;; Always true in this case, so no need to check

             ;; No position must diagonally attack our current queen
             (not (any-attacks-diagonally this-elem other-positions)))))))

(define (make-position row column)
  (cons column row))

(define (get-row position)
  (cdr position))

(define (get-column position)
  (car position))
        
(define (adjoin-position new-row k rest-of-queens)
  (cons (make-position new-row k) rest-of-queens ))

;; Check against https://en.wikipedia.org/wiki/Eight_queens_puzzle#Counting_solutions
(map (lambda (num) (length (queens num))) (list 1 2 3 4 5 6 7 8)) ; ✔

(define res4 (queens 4))
res4 ; ✔
