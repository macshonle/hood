;; Test i64 arithmetic operations
(module
  ;; Addition
  (func (export "add") (param $a i64) (param $b i64) (result i64)
    local.get $a
    local.get $b
    i64.add)

  (func (export "add_const") (result i64)
    i64.const 40
    i64.const 2
    i64.add)

  (func (export "add_overflow") (result i64)
    i64.const 0x7fffffffffffffff
    i64.const 1
    i64.add)

  (func (export "add_large") (result i64)
    i64.const 0x123456789abcdef0
    i64.const 0x0fedcba987654321
    i64.add)

  ;; Subtraction
  (func (export "sub") (param $a i64) (param $b i64) (result i64)
    local.get $a
    local.get $b
    i64.sub)

  (func (export "sub_underflow") (result i64)
    i64.const 0x8000000000000000
    i64.const 1
    i64.sub)

  ;; Multiplication
  (func (export "mul") (param $a i64) (param $b i64) (result i64)
    local.get $a
    local.get $b
    i64.mul)

  (func (export "mul_overflow") (result i64)
    i64.const 0x100000000
    i64.const 0x100000000
    i64.mul)

  ;; Division (signed)
  (func (export "div_s") (param $a i64) (param $b i64) (result i64)
    local.get $a
    local.get $b
    i64.div_s)

  (func (export "div_s_neg") (result i64)
    i64.const -10
    i64.const 3
    i64.div_s)

  ;; Division (unsigned)
  (func (export "div_u") (param $a i64) (param $b i64) (result i64)
    local.get $a
    local.get $b
    i64.div_u)

  (func (export "div_u_large") (result i64)
    i64.const 0xfffffffffffffffe
    i64.const 2
    i64.div_u)

  ;; Remainder (signed)
  (func (export "rem_s") (param $a i64) (param $b i64) (result i64)
    local.get $a
    local.get $b
    i64.rem_s)

  (func (export "rem_s_neg") (result i64)
    i64.const -10
    i64.const 3
    i64.rem_s)

  ;; Remainder (unsigned)
  (func (export "rem_u") (param $a i64) (param $b i64) (result i64)
    local.get $a
    local.get $b
    i64.rem_u)
)
