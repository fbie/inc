#lang racket

(define (emit . args)
  (displayln (apply format args)))

(define shift arithmetic-shift)

(define fixnum-shift 2)
(define char-shift 8)
(define bool-shift 7)
(define bool-tag 63)
(define true-rep (bitwise-ior (shift 1 7) bool-tag))
(define false-rep bool-tag)
(define nil-rep 23)

(define (immediate-rep x)
  (cond [(integer? x) (shift x fixnum-shift)]
        [(boolean? x) (if x true-rep false-rep)]
        [(char? x) (bitwise-ior (shift (char->integer x) char-shift) 15)]
        [(and (list? x) (eq? empty x)) nil-rep]))

(define (immediate? x)
  (or (integer? x)
      (char? x)
      (boolean? x)
      (and (list? x) (eq? empty x))))

(define const-1 (immediate-rep 1))
(define const-t (immediate-rep #t))
(define const-f (immediate-rep #f))
(define const-nil (immediate-rep '()))

(define primcall-op car)

(define (primcall-operand n e)
  (list-ref e n))

(define primcall-operand-1 (curry primcall-operand 1))
(define primcall-operand-2 (curry primcall-operand 2))
(define primcall-operand-3 (curry primcall-operand 3))

(define prims '(add1 sub1 char->integer integer->char zero?))

(define (primcall? e)
  (list? (member (primcall-op e) prims)))

(define (emit-expr e)
  (cond [(immediate? e)
         (emit "movl $~a, %eax" (immediate-rep e))]
        [(primcall? e)
          (emit-expr (primcall-operand-1 e))
          (case (primcall-op e)
           ['add1
            (emit "addl $~a, %eax" const-1)]
           ['sub1
            (emit "subl $~a, %eax" const-1)]
           ['char->integer
            (emit "sarl $6, %eax")]
           ['integer->char
            (emit "sall $5, %eax")
            (emit "orl  $15, %eax")]
           ['zero?
            (emit "cmpl $0, %eax")
            (emit "movl $0, %eax")
            (emit "sete %al")
            (emit "sall $~a, %eax" bool-shift)
            (emit "orl  $~a, %eax" bool-tag)
            ])]))

(define (compile-program x)
  (emit "movl $~a, %eax" (immediate-rep x))
  (emit "ret"))

(define (compile-scheme-entry x)
  (emit ".text")
  (emit ".p2align 4,,15")
  (emit ".globl scheme_entry")
  (emit "scheme_entry:")
  (emit-expr x)
  (emit "ret"))

(compile-scheme-entry '(zero? 0))
