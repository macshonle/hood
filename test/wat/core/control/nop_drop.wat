;; Test nop and drop instructions
(module
  ;; nop does nothing
  (func (export "nop") (result i32)
    nop
    i32.const 42
    nop)

  ;; Multiple nops
  (func (export "nop_multiple") (result i32)
    nop
    nop
    nop
    nop
    nop
    i32.const 42)

  ;; drop removes top of stack
  (func (export "drop_i32") (result i32)
    i32.const 100
    drop
    i32.const 42)

  (func (export "drop_i64") (result i64)
    i64.const 100
    drop
    i64.const 42)

  (func (export "drop_f32") (result f32)
    f32.const 100.0
    drop
    f32.const 42.0)

  (func (export "drop_f64") (result f64)
    f64.const 100.0
    drop
    f64.const 42.0)

  ;; Multiple drops
  (func (export "drop_multiple") (result i32)
    i32.const 1
    i32.const 2
    i32.const 3
    i32.const 4
    i32.const 5
    drop
    drop
    drop
    drop)  ;; Returns 1

  ;; Drop with computation
  (func (export "drop_computation") (result i32)
    i32.const 10
    i32.const 20
    i32.add   ;; 30
    drop
    i32.const 42)

  ;; Combined nop and drop
  (func (export "nop_drop_combined") (result i32)
    nop
    i32.const 100
    nop
    drop
    nop
    i32.const 42
    nop)

  ;; Drop function result
  (func $helper (result i32)
    i32.const 99)

  (func (export "drop_call_result") (result i32)
    call $helper
    drop
    i32.const 42)
)
