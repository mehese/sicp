;; Can't have code that throws errors, so these two dummies will do

(define (parallel-execute . fun-list)
  (map (lambda (x) (x)) fun-list))

(define (make-serializer)
  (lambda (x) x))

(define x 10)
(define s (make-serializer))


(begin
  (define x 10)
  (parallel-execute 
   (lambda () (set! x (* x x)))
   (lambda () (set! x (* x x x))))
  x)
;; P1 reads x -> P1 writes x -> P2 reads x -> P2 writes x -> x=1 000 000
;; P2 reads x -> P2 writes x -> P1 reads x -> P1 writes x -> x=1 000 000
;; P1 reads x twice -> P2 reads x thrice -> P1 writes x -> P2 writes x -> x = 1000
;; P1 reads x twice -> P2 reads x thrice -> P2 writes x -> P1 writes x -> x = 100
;; (same result for reverted reading order)
;; P1 reads x twice -> P2 reads x twice -> P1 writes x as 100 -> P2 reads x once as 100 -> P2 writes -> x = 10*10*100 = 10000
;; P1 reads x twice -> P2 reads x once -> P1 writes x as 100 -> P2 reads x twice as 100 -> P2 writes -> x = 10*100*100 = 100000
;; P2 reads x thrice -> P1 reads x once -> P2 writes x as 1000 -> P1 reads x once as 1000 -> P1 writes -> x = 10*1000 = 10000


(begin
  (define x 10)
  (define s (make-serializer))
  (parallel-execute 
   (s (lambda () (set! x (* x x))))
   (s (lambda () (set! x (* x x x)))))
  x)
;;
;; Two possible options are left
;;  The execution order is either 
;;     x^2 -> x^3 
;;        or
;;     x^3 -> x^2
;; Meaning the possible results are
;;     1 000 000
;;        or
;;     1 000 000
;; => Result stays the same as the operations are commutable 
;;    i.e. (x^2)^3 = (x^3)^2
