;; Test i32 arithmetic operations
(module
  ;; Addition
  (func (export "add") (param $a i32) (param $b i32) (result i32)
    local.get $a
    local.get $b
    i32.add)

  (func (export "add_const") (result i32)
    i32.const 40
    i32.const 2
    i32.add)

  (func (export "add_overflow") (result i32)
    i32.const 0x7fffffff
    i32.const 1
    i32.add)

  ;; Subtraction
  (func (export "sub") (param $a i32) (param $b i32) (result i32)
    local.get $a
    local.get $b
    i32.sub)

  (func (export "sub_underflow") (result i32)
    i32.const 0x80000000
    i32.const 1
    i32.sub)

  ;; Multiplication
  (func (export "mul") (param $a i32) (param $b i32) (result i32)
    local.get $a
    local.get $b
    i32.mul)

  (func (export "mul_overflow") (result i32)
    i32.const 0x10000
    i32.const 0x10000
    i32.mul)

  ;; Division (signed)
  (func (export "div_s") (param $a i32) (param $b i32) (result i32)
    local.get $a
    local.get $b
    i32.div_s)

  (func (export "div_s_neg") (result i32)
    i32.const -10
    i32.const 3
    i32.div_s)

  ;; Division (unsigned)
  (func (export "div_u") (param $a i32) (param $b i32) (result i32)
    local.get $a
    local.get $b
    i32.div_u)

  (func (export "div_u_large") (result i32)
    i32.const 0xfffffffe  ;; 4294967294 unsigned
    i32.const 2
    i32.div_u)

  ;; Remainder (signed)
  (func (export "rem_s") (param $a i32) (param $b i32) (result i32)
    local.get $a
    local.get $b
    i32.rem_s)

  (func (export "rem_s_neg") (result i32)
    i32.const -10
    i32.const 3
    i32.rem_s)

  ;; Remainder (unsigned)
  (func (export "rem_u") (param $a i32) (param $b i32) (result i32)
    local.get $a
    local.get $b
    i32.rem_u)
)
