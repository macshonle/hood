;; Test comment syntax

;; Line comment

(module
  ;; Comment at module level
  (func (export "f1") (result i32)  ;; Inline comment
    ;; Comment inside function
    i32.const 42)  ;; Comment after instruction

  (; Block comment ;)

  (func (export "f2") (result i32)
    (; Block comment inside function ;)
    i32.const (; inline block comment ;) 100)

  (;
    Multi-line
    block
    comment
  ;)

  (func (export "f3") (result i32)
    i32.const 1
    (;
      Multi-line comment
      inside function
    ;)
    i32.const 2
    i32.add)

  ;; Nested block comments
  (func (export "f4") (result i32)
    (; outer (; inner ;) outer ;)
    i32.const 42)

  ;; Empty block comment
  (func (export "f5") (result i32)
    (;;)
    i32.const 1)

  ;; Comments with special characters
  ;; @#$%^&*(){}[]|;:'"<>,.?/~`

  ;; Unicode in comments
  ;; Hello 世界 🌍

  ;; Comments that look like code
  ;; (func (export "fake") i32.const 99)
)
