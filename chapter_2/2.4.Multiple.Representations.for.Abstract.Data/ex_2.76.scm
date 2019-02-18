#lang sicp

;; Which organization would be most appropriate for a system in which new types must
;;  often be added? Which would be most appropriate for a system in which new operations
;;  must often be added?

;; Generic operations with explicit dispatch
; - When adding new types:
;   the branching structures in the corresponding selectors need to be updated
;
; - When adding new operations:
;   the operation needs to be implemented for every type
;   the generic operation needs to be created with the conditional branches


;; Data-directed style
; - When adding new types:
;   the and installation package that installs the selectors into the table of
;    operations needs to be updated
;
; - When adding new operations:
;   the operation needs to be implemented for every type
;   the corresponding row needs to be added to the operation table

;; Message-passing style
; - When adding new types:
;  just make sure that the generic dispatch operator contains all the relevant selectors
;
; - When adding new operations:
;   the operation needs to be implemented for every available type, no central update needed

;; When to favour which style

; Generic operations with explicit dispatch -- small amount of types and operations, types and
;  operation modifications are rare

; Data Directed style -- when the name of the operations needs to be kept coherent across
;  multiple types. For instance if the name of the operation `deriv` changes to `calculate-derivative`
;  the data directed style would be ideally suited for this approach

; Message Passing -- when we add new objects that have operations defined for them. Well suited for
;  when having a wide possible variety of objects with different methods. Can only contain monadic
;  functions, so dyadic functions cannot be implemented.