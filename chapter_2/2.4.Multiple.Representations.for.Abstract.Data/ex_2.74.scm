#lang sicp

;; Racket hash table
(#%require (only racket/base make-hash))
(#%require (only racket/base hash-set!))
(#%require (only racket/base hash-ref))

(define *org-table* (make-hash))

(define (put division employee proc)
  (hash-set! *org-table* (list division employee) proc))

(define (get division employee)
  (hash-ref *org-table* (list division employee) '()))


;; Prereqs

(define (make-record division address salary)
  (list division address salary))

(define (division-address-from-record record)
  (car record))


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;                                                                           ;;
;;                                     1                                     ;;
;;                                                                           ;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; I see this as needing two tables
;;   - Employee table, key: (division-name, employee-name): record
;;   - Division Ops Table: key: (division-name, operation-name): division-specific-op
;;
;; I guess for the purpose of this exercise one table will suffice, as we haven't
;;  yet been taught the magic of creating a new table. Thus get-record can be 


;; With this structure get-record can be just an alias for get
(define (get-record division-key employee-key)
  (get division-key employee-key))

(put 'hr 'johnny 'mock-hr-record)
(get-record 'hr 'johnny) ; ✔

(put 'ops 'mary 'mock-ops-record)
(get-record 'ops 'mary) ; ✔

(get 'ops 'johnny)
(get 'hr 'mary) ; ✔

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;                                                                           ;;
;;                                     2                                     ;;
;;                                                                           ;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; Similarly to the complex numbers case we need a way to tag a record with the
;;  division it's coming from. Then the divisions can implement their own
;;  get-salary and get-address selectors for their records

(define (attach-tag division-tag record)
  (cons division-tag record))  

(define (get-division record)
  (car record))

(define (get-record-data record)
  (cdr record))

;; HR team record constructor
(put 'hr 'make-record
     (lambda (salary address)
       (attach-tag 'hr (list "salary" salary "address" address))))

;; HR team record selectors
(put 'hr 'get-salary
     (lambda (record-data)
       (cadr record-data)))

(put 'hr 'get-address
     (lambda (record-data)
       (cadddr record-data)))

;; Ops team record constructor
(put 'ops 'make-record
     (lambda (salary address)
       (attach-tag 'ops (cons address salary))))

;; HR team record selectors
(put 'ops 'get-salary
     (lambda (record-data)
       (cdr record-data)))

(put 'ops 'get-address
     (lambda (record-data)
       (car record-data)))

(define (get-salary record)
  ((get (get-division record) 'get-salary) (get-record-data record)))

(define sample-hr-record
  ((get 'hr 'make-record)
   60000 "1 Haytcher Drive, Haytchercussets"))

(define sample-ops-record
  ((get 'ops 'make-record)
   80000 "314 Dave Oppsy Road, Poughkopsy"))

sample-hr-record
(get-salary sample-hr-record) ; ✔
sample-ops-record
(get-salary sample-ops-record) ; ✔

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;                                                                           ;;
;;                                     3                                     ;;
;;                                                                           ;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(define (find-employee-record all-divs employee-name)
  (cond
    ((null? all-divs) '())
    (else
     (let
         ((query-result (get-record (car all-divs) employee-name)))
       (if (null? query-result)
           (find-employee-record (cdr all-divs) employee-name)
           query-result)))))

(find-employee-record '(hr ops) 'johnny) ; ✔
(find-employee-record '(hr ops) 'mary) ; ✔
(find-employee-record '(hr ops) 'frederico-fellini) ; ✔

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;                                                                           ;;
;;                                     4                                     ;;
;;                                                                           ;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

; New division
; - division-name
; - make-record procedure
; - get-salary procedure
; - get-address procedure
; They can start right away with an installation package like the ones we previously
;  designed. Let's add a new team whose purpose is just slacking off

(define (install-slackers-package)
  ;; internal procedures
  (define new-team-tag 'slackers)

  (define (make-record salary address)
    (list salary address))

  (define (get-salary record)
    (car record))

  (define (get-address record)
    (cadr record))
  
  ;; interface to the rest of the system
  (put new-team-tag 'get-salary get-salary)
  (put new-team-tag 'get-address get-address)
  
  (define (tag x) (attach-tag new-team-tag x))
  (put new-team-tag 'make-record
       (lambda (s a)
         (tag (make-record s a))))
  'done)

(install-slackers-package)

(define
  sample-slackers-record
  ((get 'slackers 'make-record) 420 "3 Slackville Close"))

(get-record-data sample-slackers-record)
(get-salary sample-slackers-record)
