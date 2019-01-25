#lang sicp

(define (count-leaves x)
  (cond ((null? x) 0)
        ((not (pair? x)) 1)
        (else (+ (count-leaves (car x))
                 (count-leaves (cdr x))))))

(define x (cons (list 1 2) (list 3 4)))

; 
;(count-leaves (list x))
;(count-leaves (list x x))

(count-leaves (list 1 (list 2 (list 3 4)))) ;; Res 4

;;   (list 1 (list 2 (list 3 4))))
;;           +
;; +---------+----------+
;; v                    v
;; 1            (list 2 (list 3 4))))
;;                      +
;;            +---------+--------+
;;            v                  v
;;            2             (list 3 4)
;;                             +
;;                       +-----+-----+
;;                       v           v
;;                       3           4

;; Box and pointer copied from http://community.schemewiki.org/?sicp-ex-2.24
;;  I mean c'mon
;;                                          
;;    +---+---+  +---+---+
;;    | * | *-+->| * | / |
;;    +-+-+---+  +-+-+---+
;;      |          |   
;;      V          V      
;;    +---+      +---+---+  +---+---+
;;    | 1 |      | * | *-+->| * | / |
;;    +---+      +-+-+---+  +---+---+
;;                 |          |
;;                 V          V
;;               +---+      +---+---+  +---+---+
;;               | 2 |      | * | *-+->| * | / |
;;               +---+      +-+-+---+  +-+-+---+
;;                            |          |
;;                            V          V
;;                          +---+      +---+
;;                          | 3 |      | 4 |
;;                          +---+      +---+
