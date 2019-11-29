#lang racket

(define (emit . args)
  (displayln (apply format args)))

(define shift arithmetic-shift)

(define fixnum-shift 2)
(define char-shift 8)
(define true-rep 63)
(define false-rep (shift true-rep -1))
(define nil-rep 23)


(define (immediate-rep x)
  (cond [(integer? x) (shift x fixnum-shift)]
        [(boolean? x) (if x true-rep false-rep)]
        [(char? x) (shift (char->integer x) char-shift)]
        [(and (list? x) (eq? empty x)) nil-rep]))

(define (compile-program x)
  (emit "    movl $~a, %eax" (immediate-rep x))
  (emit "    ret"))

(define (compile-scheme-entry x)
  (emit "    .text")
  (emit "    .p2align 4,,15")
  (emit "    .globl scheme_entry")
  (emit "scheme_entry:")
  (compile-program x))

(compile-scheme-entry '())
