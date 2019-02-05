#lang sicp

;; No change here
(define (element-of-set? x set)
  ;; element-of-set? is still O(N), and that N might increase significantly with added elements
  (cond ((null? set) false)
        ((equal? x (car set)) true)
        (else (element-of-set? x (cdr set)))))

(define (adjoin-set x set)
  ;; Now is O(1) used to be O(N)
  (cons x set))

;; The requirement for intersection-set is poorly defined in this case
;;  is {a, b, c} a valid instersection of {a, a, a, b, b} {b, b, c, c} ?
;;
;; Since the exercise didn't mention it, I'll be lazy and assume that yes
(define (intersection-set set1 set2)
  ;; intersection-set is still O(N^2), but it's going to be the N's in the list
  ;;  not the number of distict elements!
  (cond ((or (null? set1) (null? set2)) 
         '())
        ((element-of-set? (car set1) set2)
         (cons (car set1)
               (intersection-set (cdr set1) 
                                 set2)))
        (else (intersection-set (cdr set1) 
                                set2))))

(define (union-set set1 set2)
  ;; Union here would be O(N) rather than O(N^2), as we don't
  ;;  need to check for duplicates, just to concatenate the lists
  (cond
    ((null? set1) set2)
    ((null? set2) set1)
    (else
     (union-set (cdr set1) (adjoin-set (car set1) set2)))))

(display "Test adjoin-set") (newline)
(adjoin-set 'a '()) ; ✔ 
(adjoin-set 'a '(a b)) ; ✔ 
(adjoin-set 'a '(b)) ; ✔ 

(display "Test intersection-set") (newline)
(intersection-set '(b b a c) '(c b d)) ; ✔ 
(intersection-set '() '(a)) ; ✔ 
(intersection-set '(a b c) '(a b c)) ; ✔ 
(intersection-set '(a b c) '(a)) ; ✔ 
(intersection-set '(a b c) '(1 2 3)) ; ✔ 
(intersection-set '(a a b c) '(a)) ; ✔ 

(display "Test union-set") (newline)
(union-set '(b a c) '(c b d)) ; ✔ 
(union-set '() '(a)) ; ✔ 
(union-set '(a b c) '(a b c)) ; ✔ 
(union-set '(a b c) '(a)) ; ✔ 
(union-set '(a b c) '(1 2 3)) ; ✔ 
(union-set '(a a b c) '(1 2 3)) ; ✔ 

;; Might be more useful to have sets implemented like this if we just want to do
;;  unions and adjoins rather than intersections and element-of-set? queries and
;;  we don't really care about memory space that much. However, we might as well be
;;  using a list in that case
