;; These tests hit the functional aspects of Outlet and ensure that
;; all of the constructs work correctly. See the tests in basic.ol for
;; more fundamental tests.

(define-macro (%test hook src val . args)
  `(let ((comp (if (null? ',args) equal? (car ',args)))
         (res (,hook ,src)))
     (if (not (comp res ,val))
         (throw (string-append "FAILURE with " (->string ',hook) ": "
                               (->string ,src)
                               " got "
                               (->string res)
                               " but expected "
                               (->string ,val))))))


(define-macro (test-read src val . args)
  `(%test read ,src ,val ,@args))

(define-macro (test-eval src val . args)
  `(%test eval-outlet ',src ,val ,@args))

;; data structures
;;
;; the main purpose of this section is to make sure literals are
;; passed through macros correctly

(test-eval '(1 2 3) (list 1 2 3))
(test-eval [1 2 3] (vector 1 2 3))
(test-eval {:foo 1 :bar 2} (hash-map :foo 1 :bar 2))

;; functions
(define (foo x y z) (+ x y z))
(test-eval (foo 1 2 3) 6)

(define (bar t) (* (foo 1 2 3) t))
(test-eval (bar 5) 30)

(test-eval ((lambda (x)
               (bar (+ x 2))) 5)
           42)

;; lambda

(define foo (lambda (x y z) (+ x y z)))
(test-eval (foo 1 2 3) 6)

(define foo (lambda args args))
(test-eval (foo 1 2 3) '(1 2 3))



;; set!
(test-eval ((lambda (x)
               (set! x 10)
               (* x x)) 5)
           100)

;; if
(test-eval (if true 1 2) 1)
(test-eval (if false 1 2) 2)
(test-eval (if true
                (begin
                  (define a 5)
                  (* a 2)))
           10)

;; cond
(define x 3)
(test-eval (cond
             ((eq? x 0) 'zero)
             ((eq? x 1) 'one)
             ((eq? x 2) 'two)
             ((eq? x 3) 'three))
           'three)

(test-eval (cond
            ((eq? x 0) 'zero)
            ((eq? x 1) 'one)
            ((eq? x 2) 'two)
            (else 'none))
           'none)


