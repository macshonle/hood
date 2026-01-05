;; Test f64 comparison operations
(module
  ;; Equal
  (func (export "eq") (param $a f64) (param $b f64) (result i32)
    local.get $a
    local.get $b
    f64.eq)

  (func (export "eq_same") (result i32)
    f64.const 1.5
    f64.const 1.5
    f64.eq)

  (func (export "eq_diff") (result i32)
    f64.const 1.5
    f64.const 2.5
    f64.eq)

  (func (export "eq_nan") (result i32)
    f64.const nan
    f64.const nan
    f64.eq)

  (func (export "eq_zero_neg_zero") (result i32)
    f64.const 0.0
    f64.const -0.0
    f64.eq)

  ;; Not equal
  (func (export "ne") (param $a f64) (param $b f64) (result i32)
    local.get $a
    local.get $b
    f64.ne)

  (func (export "ne_nan") (result i32)
    f64.const nan
    f64.const nan
    f64.ne)

  ;; Less than
  (func (export "lt") (param $a f64) (param $b f64) (result i32)
    local.get $a
    local.get $b
    f64.lt)

  (func (export "lt_true") (result i32)
    f64.const 1.0
    f64.const 2.0
    f64.lt)

  (func (export "lt_nan") (result i32)
    f64.const nan
    f64.const 1.0
    f64.lt)

  ;; Greater than
  (func (export "gt") (param $a f64) (param $b f64) (result i32)
    local.get $a
    local.get $b
    f64.gt)

  (func (export "gt_true") (result i32)
    f64.const 2.0
    f64.const 1.0
    f64.gt)

  ;; Less than or equal
  (func (export "le") (param $a f64) (param $b f64) (result i32)
    local.get $a
    local.get $b
    f64.le)

  (func (export "le_same") (result i32)
    f64.const 1.0
    f64.const 1.0
    f64.le)

  ;; Greater than or equal
  (func (export "ge") (param $a f64) (param $b f64) (result i32)
    local.get $a
    local.get $b
    f64.ge)

  (func (export "ge_same") (result i32)
    f64.const 1.0
    f64.const 1.0
    f64.ge)

  ;; Infinity comparisons
  (func (export "lt_inf") (result i32)
    f64.const 1e308
    f64.const inf
    f64.lt)

  (func (export "gt_neg_inf") (result i32)
    f64.const -1e308
    f64.const -inf
    f64.gt)
)
