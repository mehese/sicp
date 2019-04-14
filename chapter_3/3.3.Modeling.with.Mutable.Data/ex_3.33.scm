(load "connector.scm")

(define (averager a b average)

  (define (process-new-value)
    (cond
      ;; both a and b have a value
      ((and (has-value? a) (has-value? b))
       (set-value! average
                   (/ (+ (get-value a) (get-value b))
                      2) 
                   me))
      ;; we have a value for a and the average
      ((and (has-value? a) (has-value? average))
       ;; b <- 2*average - a
       (set-value! b
                   (- (* 2 (get-value average)) (get-value a))
                   me))
      ;; we have a value for b and the average
      ((and (has-value? b) (has-value? average))
       ;; a <- 2*average - b
       (set-value! a
                   (- (* 2 (get-value average)) (get-value b))
                   me))
      (else 'ingnored)
      ))

  (define (process-forget-value)
    (forget-value! average me)
    (forget-value! a me)
    (forget-value! b me)
    (process-new-value))

  (define (me request)
    (cond 
      ((eq? request 'I-have-a-value) (process-new-value))
      ((eq? request 'I-lost-my-value) (process-forget-value))
      (else (error "Unkown request: AVERAGER" request))))
  
  (connect a me)
  (connect b me)
  (connect average me)
  me)

(define A (make-connector))
(define B (make-connector))
(define res (make-connector))
(define avg-proc (averager A B res))

(set-value! A 10 'user)
(set-value! B 4 'user)
(get-value res) ; ✔ 
(forget-value! A 'user)
(set-value! A 8 'user)
(get-value res) ; ✔ 
(forget-value! A 'user)
(forget-value! B 'user)
(forget-value! res 'user)

(set-value! res 10 'user)
(set-value! B 4 'user)
(get-value A) ; ✔ 
(forget-value! B 'user)
(set-value! A 4 'user)
(get-value B) ; ✔ 
