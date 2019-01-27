#lang sicp

(define (make-mobile left right)
  (list left right))

(define (make-branch length structure)
  (list length structure))

; example mobile

(define mob1
  (make-mobile
   (make-branch 2
              (make-mobile
               (make-branch 3 10)
               (make-branch 1 5)))
   (make-branch 2 20)))
mob1

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;                                                                             ;;
;;                                      1                                      ;;
;;                                                                             ;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(define (left-branch mobile-struct)
  (car mobile-struct))

(define (right-branch mobile-struct)
  (cadr mobile-struct))

(define (branch-length branch)
  (car branch))

(define (branch-structure branch)
  (cadr branch))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;                                                                             ;;
;;                                      2                                      ;;
;;                                                                             ;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(define (total-weight struct)
  ; is it a branch or a mobile
  (if
   (not (pair? (car struct)))
   ; it's a branch
   (if (pair? (branch-structure struct)) ; if the branch contains a mobile
       (total-weight (branch-structure struct)) ; recurse to find the weight of the structure
       (branch-structure struct)) ; else return the weight
   ; it's a mobile
   (+ (total-weight (left-branch struct)) (total-weight (right-branch struct)))))

(total-weight (make-branch 2 5)) ; ✔
(total-weight (make-mobile (make-branch 10 2) (make-branch 3.14 2))) ; ✔
(total-weight mob1) ; ✔
(total-weight
  (make-mobile
   (make-branch 2
              (make-mobile
               (make-branch 3 10)
               (make-mobile
                (make-branch 1 (/ 5 2))
                (make-branch 1 (/ 5 2)))))
   (make-branch 2 20))) ; ✔

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;                                                                             ;;
;;                                      3                                      ;;
;;                                                                             ;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(define (torque-balance mobile)
  (let
      ((l (left-branch mobile))
       (r (right-branch mobile)))
     (=
      (* (branch-length l) (total-weight l))
      (* (branch-length r) (total-weight r)))))

(define (balanced? struct)
  (if (not (pair? (car struct)))
      ; it's a branch ->  #t if it's terminal, recurse if it contains a mobile
      (if (not (pair? (branch-structure struct)))
          #t
          (balanced? (branch-structure struct)))
      ; it's a mobile ->  must be balanced and recurse on branches
      (and
       (torque-balance struct)
       (balanced? (left-branch struct))
       (balanced? (right-branch struct)))))

(torque-balance
 (make-mobile
  (make-branch 2 3)
  (make-branch 3 2)))
(torque-balance mob1)

(display "Check balance") (newline)

(balanced?
 (make-mobile
  (make-branch 2 3)
  (make-branch 3 2))) ; ✔

(torque-balance mob1) ; ✔

(balanced?
 (make-mobile
  (make-branch 5 (make-mobile
                  (make-branch 1 10)
                  (make-branch 1 10)))
  (make-branch 5 20))) ; ✔

(balanced?
 (make-mobile
  (make-branch 5 (make-mobile
                  (make-branch 2 10)
                  (make-branch 1 10)))
  (make-branch 5 20))) ; ✔

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;                                                                             ;;
;;                                      4                                      ;;
;;                                                                             ;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


;; The one change that needs to be implemented is
;;
(define (right-branch-new mobile-struct) (cdr mobile-struct))
;;
;; and
;;
(define (branch-structure-new branch) (cdr branch))
;;
;; This is because (cdr (cons (cons 1 2) (cons 3 4)) = {3 . 4}
;;  while (cdr (list (list 1 2) (list 3 4)) = ((3 4))
;;
;; Otherwise our procedures are mostly blind to the internal structure except for
;;  the dirty "type snooping" via car. But luckily car behaves the same for lists
;;  and cons