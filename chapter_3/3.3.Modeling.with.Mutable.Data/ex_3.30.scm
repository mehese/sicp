;; run with
;;  racket -l sicp --repl < ex_3.29.scm
;; Don't know how to sleep sicp just yet
(#%require (only racket/base sleep))


(load "circuit_functions.scm")

(define (half-adder a b s c)
  (let ((d (make-wire)) (e (make-wire)))
    (or-gate a b d)
    (and-gate a b c)
    (inverter c e)
    (and-gate d e s)
    'ok))

(define (full-adder a b c-in sum c-out)
  (let ((c1 (make-wire)) 
        (c2 (make-wire))
        (s  (make-wire)))
    (half-adder b c-in s c1)
    (half-adder a s sum c2)
    (or-gate c1 c2 c-out)
    'ok))

(define (generate-n-wires n)
  (define (wire-iter wire-list wires-left)
    (if (= wires-left 0)
      wire-list
      (wire-iter 
	(cons (make-wire) wire-list)
	(dec wires-left))))
  

  (wire-iter '() n))

(define (ripple-carry-adder As Bs Ss Cin)
  (define Cs (generate-n-wires (length As)))

  (define (create-ripple As-left Bs-left Ss-left Cs-left)
    (if (or (null? As-left) (null? Bs-left))
      ;; Return output wire
      (begin 
				(newline)
				(car Cs-left))
      ;; Generate current full adder
      (let 
				((An (car As-left)) 
				 (Bn (car Bs-left)) 
				 (Sn (car Ss-left)) 
				 (Cn (car Cs-left)) 
				 (Cn+1 (cadr Cs-left)) 
				 (next-As (cdr As-left)) 
				 (next-Bs (cdr Bs-left)) 
				 (next-Ss (cdr Ss-left)) 
				 (next-Cs (cdr Cs-left)))
				(display (length As-left))
				(full-adder An Bn Cn Sn Cn+1)
				;; Proceed to next iteration
				(create-ripple next-As next-Bs next-Ss next-Cs))))
	
	(create-ripple As Bs Ss (cons Cin Cs)))

(define (show-wire w)
  (display (get-signal w))
  (newline))

;; For quite a while I was trying to debug this program, just to
;;  realize I was printing numbers backwards
(define (show-binary wlist)
	(define (print-all-nums lst)
		(if (null? lst)
				(newline)
				(begin
					(display (get-signal (car lst)))
					(print-all-nums (cdr lst)))))
	(print-all-nums (reverse wlist)))

(define (null-wire w) (set-signal! w 0))

(define (random-flip! wire) (set-signal! wire (random 2)))

(define A5 (generate-n-wires 5))
(define B5 (generate-n-wires 5))
(define S5 (generate-n-wires 5))
(define Cin5 (make-wire))

(display "Creating Ripple Adder") (newline)
(define Cout5 (ripple-carry-adder A5 B5 S5 Cin5))
(display "Adder created") (newline)

;; This is needed to prime the currents on all the inverters
(map null-wire A5)
(map null-wire B5)
(display "S = ") (show-binary S5)
(show-wire Cout5)
(map random-flip! A5)
(random-flip! Cin5)
(display "Cin = ") (show-wire Cin5)
(display "A = ") (show-binary A5)
(display "S = ") (show-binary S5)
(map random-flip! B5)
(display "Cin = ") (show-wire Cin5)
(display "A = ") (show-binary A5)
(display "B = ") (show-binary B5)
(display "S = ") (show-binary S5)
(show-wire Cout5)

;; Time to run
;; *if* I wouldn't trigger everything in series
;;(define inverter-delay 0.005)
;;(define and-gate-delay 0.003)
;;(define or-gate-delay  0.004)
;;
;;  Time_Half_Adder = ( 2*and-gate-delay + inverter-delay + or-gate-delay)
;;      [OR] = max(or-gate-delay, (inverter-delay + and-gate-delay)) + and-gate-delay
;; 
;;  Time_Full_Adder = ( 2*Time_Half_Adder + or-gate-delay )
;;
;;  Time_Ripple_Adder = N * Time_Full_Adder
;;
;; Actually this takes absolutely AGES to run for bigger numbers, as every bit flip
;;   triggers a lot of computation down the line. With smarter trigerring and some 
;;   parallel evaluation this could be fixed.
