;; Test i64 comparison operations
(module
  ;; Equal
  (func (export "eq") (param $a i64) (param $b i64) (result i32)
    local.get $a
    local.get $b
    i64.eq)

  (func (export "eq_same") (result i32)
    i64.const 42
    i64.const 42
    i64.eq)

  (func (export "eq_diff") (result i32)
    i64.const 42
    i64.const 43
    i64.eq)

  (func (export "eq_large") (result i32)
    i64.const 0x123456789abcdef0
    i64.const 0x123456789abcdef0
    i64.eq)

  ;; Not equal
  (func (export "ne") (param $a i64) (param $b i64) (result i32)
    local.get $a
    local.get $b
    i64.ne)

  ;; Less than (signed)
  (func (export "lt_s") (param $a i64) (param $b i64) (result i32)
    local.get $a
    local.get $b
    i64.lt_s)

  (func (export "lt_s_neg") (result i32)
    i64.const -1
    i64.const 1
    i64.lt_s)

  ;; Less than (unsigned)
  (func (export "lt_u") (param $a i64) (param $b i64) (result i32)
    local.get $a
    local.get $b
    i64.lt_u)

  (func (export "lt_u_neg") (result i32)
    i64.const -1   ;; max unsigned
    i64.const 1
    i64.lt_u)

  ;; Greater than (signed)
  (func (export "gt_s") (param $a i64) (param $b i64) (result i32)
    local.get $a
    local.get $b
    i64.gt_s)

  ;; Greater than (unsigned)
  (func (export "gt_u") (param $a i64) (param $b i64) (result i32)
    local.get $a
    local.get $b
    i64.gt_u)

  (func (export "gt_u_neg") (result i32)
    i64.const -1   ;; max unsigned
    i64.const 1
    i64.gt_u)

  ;; Less than or equal (signed)
  (func (export "le_s") (param $a i64) (param $b i64) (result i32)
    local.get $a
    local.get $b
    i64.le_s)

  ;; Less than or equal (unsigned)
  (func (export "le_u") (param $a i64) (param $b i64) (result i32)
    local.get $a
    local.get $b
    i64.le_u)

  ;; Greater than or equal (signed)
  (func (export "ge_s") (param $a i64) (param $b i64) (result i32)
    local.get $a
    local.get $b
    i64.ge_s)

  ;; Greater than or equal (unsigned)
  (func (export "ge_u") (param $a i64) (param $b i64) (result i32)
    local.get $a
    local.get $b
    i64.ge_u)
)
