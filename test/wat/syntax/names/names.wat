;; Test identifier names
(module
  ;; Simple names
  (func $simple (result i32) i32.const 1)
  (func $with_underscore (result i32) i32.const 2)
  (func $with123numbers (result i32) i32.const 3)
  (func $_leading_underscore (result i32) i32.const 4)

  ;; Names with special characters (allowed in WAT)
  (func $name! (result i32) i32.const 5)
  (func $name# (result i32) i32.const 6)
  (func $name$ (result i32) i32.const 7)
  (func $name% (result i32) i32.const 8)
  (func $name& (result i32) i32.const 9)
  (func $name' (result i32) i32.const 10)
  (func $name* (result i32) i32.const 11)
  (func $name+ (result i32) i32.const 12)
  (func $name- (result i32) i32.const 13)
  (func $name. (result i32) i32.const 14)
  (func $name/ (result i32) i32.const 15)
  (func $name: (result i32) i32.const 16)
  (func $name< (result i32) i32.const 17)
  (func $name= (result i32) i32.const 18)
  (func $name> (result i32) i32.const 19)
  (func $name? (result i32) i32.const 20)
  (func $name@ (result i32) i32.const 21)
  (func $name^ (result i32) i32.const 22)
  (func $name_ (result i32) i32.const 23)
  (func $name` (result i32) i32.const 24)
  (func $name| (result i32) i32.const 25)
  (func $name~ (result i32) i32.const 26)

  ;; Combined special characters
  (func $a->b (result i32) i32.const 27)
  (func $is-valid? (result i32) i32.const 28)
  (func $foo::bar (result i32) i32.const 29)
  (func $<init> (result i32) i32.const 30)

  ;; Long name
  (func $this_is_a_very_long_function_name_that_should_still_work_correctly (result i32)
    i32.const 31)

  ;; Exports with named functions
  (export "simple" (func $simple))
  (export "with_underscore" (func $with_underscore))
  (export "arrow" (func $a->b))
  (export "question" (func $is-valid?))

  ;; Global names
  (global $my-global i32 (i32.const 100))
  (global $another.global (mut i32) (i32.const 200))

  ;; Memory names
  (memory $main-memory 1)

  ;; Table names
  (table $func-table 4 funcref)

  ;; Type names
  (type $my-type (func (param i32) (result i32)))
)
