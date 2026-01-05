;; Test f32 arithmetic operations
(module
  ;; Addition
  (func (export "add") (param $a f32) (param $b f32) (result f32)
    local.get $a
    local.get $b
    f32.add)

  (func (export "add_const") (result f32)
    f32.const 1.5
    f32.const 2.5
    f32.add)

  (func (export "add_inf") (result f32)
    f32.const inf
    f32.const 1.0
    f32.add)

  (func (export "add_inf_neg_inf") (result f32)
    f32.const inf
    f32.const -inf
    f32.add)  ;; Should be nan

  ;; Subtraction
  (func (export "sub") (param $a f32) (param $b f32) (result f32)
    local.get $a
    local.get $b
    f32.sub)

  (func (export "sub_const") (result f32)
    f32.const 5.5
    f32.const 2.5
    f32.sub)

  ;; Multiplication
  (func (export "mul") (param $a f32) (param $b f32) (result f32)
    local.get $a
    local.get $b
    f32.mul)

  (func (export "mul_const") (result f32)
    f32.const 3.0
    f32.const 4.0
    f32.mul)

  (func (export "mul_zero_inf") (result f32)
    f32.const 0.0
    f32.const inf
    f32.mul)  ;; Should be nan

  ;; Division
  (func (export "div") (param $a f32) (param $b f32) (result f32)
    local.get $a
    local.get $b
    f32.div)

  (func (export "div_const") (result f32)
    f32.const 10.0
    f32.const 4.0
    f32.div)

  (func (export "div_by_zero") (result f32)
    f32.const 1.0
    f32.const 0.0
    f32.div)  ;; Should be inf

  (func (export "div_zero_by_zero") (result f32)
    f32.const 0.0
    f32.const 0.0
    f32.div)  ;; Should be nan

  ;; Minimum
  (func (export "min") (param $a f32) (param $b f32) (result f32)
    local.get $a
    local.get $b
    f32.min)

  (func (export "min_const") (result f32)
    f32.const 3.0
    f32.const 2.0
    f32.min)

  (func (export "min_neg_zero") (result f32)
    f32.const 0.0
    f32.const -0.0
    f32.min)  ;; Should be -0.0

  ;; Maximum
  (func (export "max") (param $a f32) (param $b f32) (result f32)
    local.get $a
    local.get $b
    f32.max)

  (func (export "max_const") (result f32)
    f32.const 3.0
    f32.const 2.0
    f32.max)

  ;; Copysign
  (func (export "copysign") (param $a f32) (param $b f32) (result f32)
    local.get $a
    local.get $b
    f32.copysign)

  (func (export "copysign_pos_neg") (result f32)
    f32.const 5.0
    f32.const -1.0
    f32.copysign)

  (func (export "copysign_neg_pos") (result f32)
    f32.const -5.0
    f32.const 1.0
    f32.copysign)
)
