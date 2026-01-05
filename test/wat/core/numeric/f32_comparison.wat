;; Test f32 comparison operations
(module
  ;; Equal
  (func (export "eq") (param $a f32) (param $b f32) (result i32)
    local.get $a
    local.get $b
    f32.eq)

  (func (export "eq_same") (result i32)
    f32.const 1.5
    f32.const 1.5
    f32.eq)

  (func (export "eq_diff") (result i32)
    f32.const 1.5
    f32.const 2.5
    f32.eq)

  (func (export "eq_nan") (result i32)
    f32.const nan
    f32.const nan
    f32.eq)  ;; Should be 0 (false)

  (func (export "eq_zero_neg_zero") (result i32)
    f32.const 0.0
    f32.const -0.0
    f32.eq)  ;; Should be 1 (true)

  ;; Not equal
  (func (export "ne") (param $a f32) (param $b f32) (result i32)
    local.get $a
    local.get $b
    f32.ne)

  (func (export "ne_nan") (result i32)
    f32.const nan
    f32.const nan
    f32.ne)  ;; Should be 1 (true)

  ;; Less than
  (func (export "lt") (param $a f32) (param $b f32) (result i32)
    local.get $a
    local.get $b
    f32.lt)

  (func (export "lt_true") (result i32)
    f32.const 1.0
    f32.const 2.0
    f32.lt)

  (func (export "lt_nan") (result i32)
    f32.const nan
    f32.const 1.0
    f32.lt)  ;; Should be 0 (false)

  ;; Greater than
  (func (export "gt") (param $a f32) (param $b f32) (result i32)
    local.get $a
    local.get $b
    f32.gt)

  (func (export "gt_true") (result i32)
    f32.const 2.0
    f32.const 1.0
    f32.gt)

  ;; Less than or equal
  (func (export "le") (param $a f32) (param $b f32) (result i32)
    local.get $a
    local.get $b
    f32.le)

  (func (export "le_same") (result i32)
    f32.const 1.0
    f32.const 1.0
    f32.le)

  ;; Greater than or equal
  (func (export "ge") (param $a f32) (param $b f32) (result i32)
    local.get $a
    local.get $b
    f32.ge)

  (func (export "ge_same") (result i32)
    f32.const 1.0
    f32.const 1.0
    f32.ge)

  ;; Infinity comparisons
  (func (export "lt_inf") (result i32)
    f32.const 1e38
    f32.const inf
    f32.lt)

  (func (export "gt_neg_inf") (result i32)
    f32.const -1e38
    f32.const -inf
    f32.gt)
)
