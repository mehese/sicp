;; Can't have code that throws errors, so these two dummies will do

(define (parallel-execute . fun-list)
  (map (lambda (x) (x)) fun-list))

(define (make-serializer)
  (lambda (x) x))

(define x 10)
(define s (make-serializer))
(parallel-execute 
  (lambda () 
    (set! x ((s (lambda () (* x x))))))
  (s (lambda () (set! x (+ x 1)))))

;; Options
;;  101
;;  x <- 10^2
;;  x <- 101
;;
;;  121
;;  x <- 11
;;  x <- 11^2
;;
;;  ... but wait, there's more!
;;
;;  100
;;  P1 reads in the value 10
;;  x <- 11 P2 works on it
;;  x <- 100 set! is unserialized and can now write stuff
;;   i.e. the access is serialized but the write isn't
;;
;; Now I was ready to hang it here, but then read the following link
;;       http://community.schemewiki.org/?sicp-ex-3.39
;;
;; I was convinced by the argument saying that 11 is a valid response.
;;  This is because the serializer guarantees that two resources *using it*
;;  will not run concomitantly, not that once a procedure is serialized
;;  no other is allowed to access the resources it accesses.
;;
;; So the fourth option is
;; P1 reads x as 10 also P1 serialization stops
;; P2 reads x as 10
;; P1 writes x as 100
;; P2 writes x as 11
