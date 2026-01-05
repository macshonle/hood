;; Test f32 unary operations
(module
  ;; Absolute value
  (func (export "abs") (param $a f32) (result f32)
    local.get $a
    f32.abs)

  (func (export "abs_pos") (result f32)
    f32.const 5.0
    f32.abs)

  (func (export "abs_neg") (result f32)
    f32.const -5.0
    f32.abs)

  (func (export "abs_neg_zero") (result f32)
    f32.const -0.0
    f32.abs)

  ;; Negation
  (func (export "neg") (param $a f32) (result f32)
    local.get $a
    f32.neg)

  (func (export "neg_pos") (result f32)
    f32.const 5.0
    f32.neg)

  (func (export "neg_neg") (result f32)
    f32.const -5.0
    f32.neg)

  (func (export "neg_zero") (result f32)
    f32.const 0.0
    f32.neg)

  ;; Square root
  (func (export "sqrt") (param $a f32) (result f32)
    local.get $a
    f32.sqrt)

  (func (export "sqrt_4") (result f32)
    f32.const 4.0
    f32.sqrt)

  (func (export "sqrt_2") (result f32)
    f32.const 2.0
    f32.sqrt)

  (func (export "sqrt_neg") (result f32)
    f32.const -1.0
    f32.sqrt)  ;; Should be nan

  ;; Ceiling
  (func (export "ceil") (param $a f32) (result f32)
    local.get $a
    f32.ceil)

  (func (export "ceil_pos") (result f32)
    f32.const 2.3
    f32.ceil)

  (func (export "ceil_neg") (result f32)
    f32.const -2.3
    f32.ceil)

  ;; Floor
  (func (export "floor") (param $a f32) (result f32)
    local.get $a
    f32.floor)

  (func (export "floor_pos") (result f32)
    f32.const 2.7
    f32.floor)

  (func (export "floor_neg") (result f32)
    f32.const -2.7
    f32.floor)

  ;; Truncate
  (func (export "trunc") (param $a f32) (result f32)
    local.get $a
    f32.trunc)

  (func (export "trunc_pos") (result f32)
    f32.const 2.7
    f32.trunc)

  (func (export "trunc_neg") (result f32)
    f32.const -2.7
    f32.trunc)

  ;; Round to nearest (ties to even)
  (func (export "nearest") (param $a f32) (result f32)
    local.get $a
    f32.nearest)

  (func (export "nearest_2_5") (result f32)
    f32.const 2.5
    f32.nearest)  ;; Should be 2.0 (ties to even)

  (func (export "nearest_3_5") (result f32)
    f32.const 3.5
    f32.nearest)  ;; Should be 4.0 (ties to even)

  (func (export "nearest_2_3") (result f32)
    f32.const 2.3
    f32.nearest)

  (func (export "nearest_2_7") (result f32)
    f32.const 2.7
    f32.nearest)
)
