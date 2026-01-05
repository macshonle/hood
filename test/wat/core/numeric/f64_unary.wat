;; Test f64 unary operations
(module
  ;; Absolute value
  (func (export "abs") (param $a f64) (result f64)
    local.get $a
    f64.abs)

  (func (export "abs_pos") (result f64)
    f64.const 5.0
    f64.abs)

  (func (export "abs_neg") (result f64)
    f64.const -5.0
    f64.abs)

  (func (export "abs_neg_zero") (result f64)
    f64.const -0.0
    f64.abs)

  (func (export "abs_inf") (result f64)
    f64.const -inf
    f64.abs)

  ;; Negation
  (func (export "neg") (param $a f64) (result f64)
    local.get $a
    f64.neg)

  (func (export "neg_pos") (result f64)
    f64.const 5.0
    f64.neg)

  (func (export "neg_neg") (result f64)
    f64.const -5.0
    f64.neg)

  (func (export "neg_zero") (result f64)
    f64.const 0.0
    f64.neg)

  ;; Square root
  (func (export "sqrt") (param $a f64) (result f64)
    local.get $a
    f64.sqrt)

  (func (export "sqrt_4") (result f64)
    f64.const 4.0
    f64.sqrt)

  (func (export "sqrt_2") (result f64)
    f64.const 2.0
    f64.sqrt)

  (func (export "sqrt_neg") (result f64)
    f64.const -1.0
    f64.sqrt)

  ;; Ceiling
  (func (export "ceil") (param $a f64) (result f64)
    local.get $a
    f64.ceil)

  (func (export "ceil_pos") (result f64)
    f64.const 2.3
    f64.ceil)

  (func (export "ceil_neg") (result f64)
    f64.const -2.3
    f64.ceil)

  ;; Floor
  (func (export "floor") (param $a f64) (result f64)
    local.get $a
    f64.floor)

  (func (export "floor_pos") (result f64)
    f64.const 2.7
    f64.floor)

  (func (export "floor_neg") (result f64)
    f64.const -2.7
    f64.floor)

  ;; Truncate
  (func (export "trunc") (param $a f64) (result f64)
    local.get $a
    f64.trunc)

  (func (export "trunc_pos") (result f64)
    f64.const 2.7
    f64.trunc)

  (func (export "trunc_neg") (result f64)
    f64.const -2.7
    f64.trunc)

  ;; Round to nearest (ties to even)
  (func (export "nearest") (param $a f64) (result f64)
    local.get $a
    f64.nearest)

  (func (export "nearest_2_5") (result f64)
    f64.const 2.5
    f64.nearest)

  (func (export "nearest_3_5") (result f64)
    f64.const 3.5
    f64.nearest)

  (func (export "nearest_2_3") (result f64)
    f64.const 2.3
    f64.nearest)

  (func (export "nearest_2_7") (result f64)
    f64.const 2.7
    f64.nearest)
)
