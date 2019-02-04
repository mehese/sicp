#lang sicp

(car ''abracadabra)

;; Returns quote too
(car (quote (quote a)))
(car '(quote a))

;; Returns a
(car (quote (a)))
(car '(a))

;; (car ''abracadabra) is translated as (car '(quote abracadabra))
;;  which returns quote