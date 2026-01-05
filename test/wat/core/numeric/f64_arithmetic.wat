;; Test f64 arithmetic operations
(module
  ;; Addition
  (func (export "add") (param $a f64) (param $b f64) (result f64)
    local.get $a
    local.get $b
    f64.add)

  (func (export "add_const") (result f64)
    f64.const 1.5
    f64.const 2.5
    f64.add)

  (func (export "add_inf") (result f64)
    f64.const inf
    f64.const 1.0
    f64.add)

  (func (export "add_inf_neg_inf") (result f64)
    f64.const inf
    f64.const -inf
    f64.add)

  (func (export "add_precision") (result f64)
    f64.const 0.1
    f64.const 0.2
    f64.add)

  ;; Subtraction
  (func (export "sub") (param $a f64) (param $b f64) (result f64)
    local.get $a
    local.get $b
    f64.sub)

  (func (export "sub_const") (result f64)
    f64.const 5.5
    f64.const 2.5
    f64.sub)

  ;; Multiplication
  (func (export "mul") (param $a f64) (param $b f64) (result f64)
    local.get $a
    local.get $b
    f64.mul)

  (func (export "mul_const") (result f64)
    f64.const 3.0
    f64.const 4.0
    f64.mul)

  (func (export "mul_zero_inf") (result f64)
    f64.const 0.0
    f64.const inf
    f64.mul)

  ;; Division
  (func (export "div") (param $a f64) (param $b f64) (result f64)
    local.get $a
    local.get $b
    f64.div)

  (func (export "div_const") (result f64)
    f64.const 10.0
    f64.const 4.0
    f64.div)

  (func (export "div_by_zero") (result f64)
    f64.const 1.0
    f64.const 0.0
    f64.div)

  (func (export "div_zero_by_zero") (result f64)
    f64.const 0.0
    f64.const 0.0
    f64.div)

  ;; Minimum
  (func (export "min") (param $a f64) (param $b f64) (result f64)
    local.get $a
    local.get $b
    f64.min)

  (func (export "min_neg_zero") (result f64)
    f64.const 0.0
    f64.const -0.0
    f64.min)

  ;; Maximum
  (func (export "max") (param $a f64) (param $b f64) (result f64)
    local.get $a
    local.get $b
    f64.max)

  ;; Copysign
  (func (export "copysign") (param $a f64) (param $b f64) (result f64)
    local.get $a
    local.get $b
    f64.copysign)

  (func (export "copysign_pos_neg") (result f64)
    f64.const 5.0
    f64.const -1.0
    f64.copysign)

  (func (export "copysign_neg_pos") (result f64)
    f64.const -5.0
    f64.const 1.0
    f64.copysign)
)
