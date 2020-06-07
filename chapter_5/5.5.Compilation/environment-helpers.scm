;; From Exercise 5.39

(define (address-frame-index addr)
  (car addr))

(define (address-variable-index addr)
  (cadr addr))

(define (lexical-address-lookup addr env)
  ;; list-ref works like vector-ref and it saves me a lot of cdr-ing
  ;; it might be a bit cheaty, but gimme a break here
  (let*
      ((fi         (car addr)) ;; frame index
       (vi         (cadr addr)) ;; variable index
       (the-frame  (list-ref env fi))
       (the-vars   (frame-variables the-frame))
       (the-values (frame-values the-frame))
       (the-var    (list-ref the-vars vi))
       (the-value  (list-ref the-values vi)))

    (if (eq? the-value '*unassigned*)
        (error "Value is unassigned for variable" the-var)
        the-value)))

(define (list-set! val lst index)
  (if (= 0 index)
      (set-car! lst val)
      (list-set! val (cdr lst) (- index 1))))

(define (lexical-address-set! val addr env)
  (let*
      ((fi         (car addr)) ;; frame index
       (vi         (cadr addr)) ;; variable index
       (the-frame  (list-ref env fi))
       (the-vars   (frame-variables the-frame))
       (the-values (frame-values the-frame)))
    (list-set! val the-values vi)
    )
  'ok)

;; From Exercise 5.40

;; helper when extending an environment with unassigned values. Generates
;;  a vector of length n of *unassigned*'s
(define (generate-initial-values n)
    (define (iterate curr-vals i)
      (if (= i n)
          curr-vals
          (iterate (cons '*unassigned* curr-vals) (+ i 1)))
      )
    (iterate '() 0))

;; I am not sure why we don't initialize these variables as unassigned for now.
;;  Especially after going through the trouble of raising errors in
;;  lexical-address lookup.
(define (extend-c-env variables c-env)
  (cons variables c-env))
(define (setup-c-env) '())


;; From Exercise 5.41

(define (list-index elem lst)
  (define (iterate i lst)
    (cond
      ((null? lst) (error "Element not found in list"))
      ((eq? elem (car lst)) i)
      (else (iterate (+ i 1) (cdr lst)))))
  (iterate 0 lst))
        

(define (find-variable var compile-env)
  (define (iterate current-frame-index c-env)
    (cond
      ((null? c-env) 'not-found)
      ((member var (car c-env))
       ;; goes through the list twice when the element is in the list,
       ;;  so not the nicest way to go about it
       (list current-frame-index
             (list-index var (car c-env))))
      (else
       (iterate (+ current-frame-index 1) (cdr c-env)))))
  (iterate 0 compile-env))