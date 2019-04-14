(load "connector.scm")
(load "cp_elements.scm")

(define (squarer a b) (multiplier a a b))


(define A (make-connector))
(define B (make-connector))

(squarer A B)

(set-value! A 2 'me)

(get-value B) ;; So far so good

(forget-value! A 'me)
(has-value? A)

(set-value! B 25 'me)
(has-value? A) ;; -> #f 
;; The multiplier procedure cannot calculate square roots
;;  as it sees too empty inputs, which makes the multiplication undefined
