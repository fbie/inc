#lang racket

(define (emit . args)
  (displayln (apply format args)))

(define (compile-program x)
  (emit "    movl $~a, %eax" 42)
  (emit "    ret"))

(define (compile-scheme-entry x)
  (emit "    .text")
  (emit "    .p2align 4,,15")
  (emit "    .globl scheme_entry")
  (emit "scheme_entry:")
  (compile-program x))

(compile-scheme-entry 42)
