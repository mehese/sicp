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
      (cons low (enumerate-interval (+ low 1) high))))

(define (accumulate-n op init seqs)
  (if (null? (car seqs))
      nil
      (cons (accumulate op init (map car seqs)) ; sum over first element of provided lists
            (accumulate-n op init (map cdr seqs)))))


(define empty-board nil)

(define (all lst) (accumulate (lambda (a b) (and a b)) #t lst))
(define (any lst) (accumulate (lambda (a b) (or a b)) #f lst))
(define (same-row pos1 pos2) (= (get-row pos1) (get-row pos2)))
(define (any-on-same-row position-to-check positions-of-others)
  (any (map (lambda (position) (same-row position-to-check position))
        positions-of-others)))

(define (attacks-diagonally queen-low queen-high)
  (cond ((>= (get-column queen-low) (get-column queen-high))
         (error "queen high should always be placed on a higher column")))

   (= (abs (- (get-row queen-high) (get-row queen-low)))
      (- (get-column queen-high) (get-column queen-low))))

(define (any-attacks-diagonally position-to-check positions-of-others)
  (any (map (lambda (position) (attacks-diagonally position position-to-check))
            positions-of-others)))

(define (safe? k positions)
  (cond
    ((null? (cdr positions)) #t)
    (else (let
              ((this-elem (car positions))
               (other-positions (cdr positions)))
            (and
             (not (any-on-same-row this-elem other-positions))
             (not (any-attacks-diagonally this-elem other-positions)))))))

(define (make-position row column)
  (cons column row))

(define (get-row position)
  (cdr position))

(define (get-column position)
  (car position))
        
(define (adjoin-position new-row k rest-of-queens)
  (cons (make-position new-row k) rest-of-queens ))

;; Implementation

;; Old
(define (queens-old board-size)
  (define (queen-cols k)
    (if (= k 0)
        (list empty-board)
        (filter
         (lambda (positions) (safe? k positions))
         (flatmap
          (lambda (rest-of-queens)
            (map (lambda (new-row)
                   (adjoin-position 
                    new-row k rest-of-queens))
                 (enumerate-interval 1 board-size)))
          (queen-cols (- k 1)))))) ;; queen-calls gets called once per call -iterative
  (queen-cols board-size))


;; Louis
(define (queens-new board-size)
  (define (queen-cols k)
    (if (= k 0)
        (list empty-board)
        (filter 
         (lambda (positions) (safe? k positions))
         (flatmap
          (lambda (new-row)
            (map (lambda (rest-of-queens)
                   (adjoin-position 
                    new-row k rest-of-queens))
                 (queen-cols (- k 1)))) ;; Queen-cols gets called board-size time at each call *recursively*!!!
          (enumerate-interval 1 board-size)))))
  (queen-cols board-size))


;; Check against https://en.wikipedia.org/wiki/Eight_queens_puzzle#Counting_solutions
(map (lambda (num) (length (queens-old num))) (list 1 2 3 4 5 6 7))
(map (lambda (num) (length (queens-new num))) (list 1 2 3 4 5 6 7))


(define res1 (queens-old 4)) ;; Gets called board-size + 1
(newline)
(define res2 (queens-new 4)) ;; queen-cols gets called
                             ;;     2 times for board-size = 1
                             ;;     7 times for board-size = 2
                             ;;    40 times for board-size = 3
                             ;;   341 times for board-size = 4
                             ;;  3906 times for board-size = 5

(define start-old (runtime))
(define res-old8 (queens-old 8))
(newline)
(/ (- (runtime) start-old) 1e6) ;; 0.022 seconds

(define start-new (runtime))
(define res-new8 (queens-new 8))
(newline)
(/ (- (runtime) start-new) 1e6) ; Doesn't take that long, 40s lol. Thinkpad is 💪 af

;; Given the recursive calls T is multiplied board-size times for board-size calls
;;  resulting in a board-size^board-size time increase
;; For an 8x8 board T_new ~ 8^8 T = 16777216T. In practice 1818x time of running the old routine