(load "connector.scm")
(load "cp_elements.scm")

;; We don't  have a division primitive yet
(define (divider m1 m2 division-result)
  (define (process-new-value)
    (cond ((and (has-value? m1) (= (get-value m1) 0))
           (set-value! division-result 0 me))
          ((and (has-value? m2) (= (get-value m2) 0))
           (error "Division by 0!"))
          ((and (has-value? m1) 
                (has-value? m2))
           (set-value! division-result
                       (/ (get-value m1) 
                          (get-value m2))
                       me))
          ((and (has-value? division-result) (has-value? m1))
           (set-value! m2
                       (* (get-value division-result) (get-value m1))
                       me))
          ((and (has-value? division-result) 
                (has-value? m2))
           (set-value! m1
                       (* (get-value division-result) (get-value m2))
                       me))))
  (define (process-forget-value)
    (forget-value! division-result me)
    (forget-value! m1 me)
    (forget-value! m2 me)
    (process-new-value))
  (define (me request)
    (cond ((eq? request 'I-have-a-value) (process-new-value))
          ((eq? request 'I-lost-my-value) (process-forget-value))
          (else (error "Unknown request: DIVIDER" request))))
  (connect m1 me)
  (connect m2 me)
  (connect division-result me)
  me)


(define (c+ x y)
  (let ((z (make-connector)))
    (adder x y z)
    z))

(define (c* x y)
  (let ((z (make-connector)))
    (multiplier x y z)
    z))


(define (c/ x y)
  (let ((z (make-connector)))
    ;; Alternatively use (multiplier z y x)
    (divider x y z)
    z))


(define (cv C)
  (let ((x (make-connector)))
    (constant C x)
    x))


(define (celsius-fahrenheit-converter x)
  (c+ (c* (c/ (cv 9) (cv 5))
          x)
      (cv 32)))

(define C (make-connector))
(define F (celsius-fahrenheit-converter C))

(set-value! F 100.0 'user)
(get-value C) ; ✔ 
(forget-value! F 'user)
(set-value! C 25.0 'user)
(get-value F) ; ✔ 
