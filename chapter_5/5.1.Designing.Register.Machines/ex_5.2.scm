#lang sicp

;; Factorial register-machine language description. So far the book
;;  not hyper clear about how to deal with initializations and function
;;  parameters. Should n be in a register or can we assume that it's a
;;  pre defined constant?

'(controller
  ;; Initializations -- book doesn't clarify if they belong here or not
  (assign p (const 1))
  (assign c (const 1))
  test-c
  ;; Also no mention so far how we intialize n
  (test (op >) (reg c) (const n))
  (branch (label fact-done))
  (assign p (op mul) (reg c) (reg p))
  (assign c (op add) (reg c) (const 1))
  (goto (label test-c))
  fact-done)