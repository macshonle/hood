;; Test i32 comparison operations
(module
  ;; Equal
  (func (export "eq") (param $a i32) (param $b i32) (result i32)
    local.get $a
    local.get $b
    i32.eq)

  (func (export "eq_same") (result i32)
    i32.const 42
    i32.const 42
    i32.eq)

  (func (export "eq_diff") (result i32)
    i32.const 42
    i32.const 43
    i32.eq)

  ;; Not equal
  (func (export "ne") (param $a i32) (param $b i32) (result i32)
    local.get $a
    local.get $b
    i32.ne)

  (func (export "ne_same") (result i32)
    i32.const 42
    i32.const 42
    i32.ne)

  (func (export "ne_diff") (result i32)
    i32.const 42
    i32.const 43
    i32.ne)

  ;; Less than (signed)
  (func (export "lt_s") (param $a i32) (param $b i32) (result i32)
    local.get $a
    local.get $b
    i32.lt_s)

  (func (export "lt_s_neg") (result i32)
    i32.const -1
    i32.const 1
    i32.lt_s)

  ;; Less than (unsigned)
  (func (export "lt_u") (param $a i32) (param $b i32) (result i32)
    local.get $a
    local.get $b
    i32.lt_u)

  (func (export "lt_u_neg") (result i32)
    i32.const -1   ;; 0xffffffff unsigned
    i32.const 1
    i32.lt_u)

  ;; Greater than (signed)
  (func (export "gt_s") (param $a i32) (param $b i32) (result i32)
    local.get $a
    local.get $b
    i32.gt_s)

  (func (export "gt_s_neg") (result i32)
    i32.const -1
    i32.const 1
    i32.gt_s)

  ;; Greater than (unsigned)
  (func (export "gt_u") (param $a i32) (param $b i32) (result i32)
    local.get $a
    local.get $b
    i32.gt_u)

  (func (export "gt_u_neg") (result i32)
    i32.const -1   ;; 0xffffffff unsigned
    i32.const 1
    i32.gt_u)

  ;; Less than or equal (signed)
  (func (export "le_s") (param $a i32) (param $b i32) (result i32)
    local.get $a
    local.get $b
    i32.le_s)

  (func (export "le_s_same") (result i32)
    i32.const 42
    i32.const 42
    i32.le_s)

  ;; Less than or equal (unsigned)
  (func (export "le_u") (param $a i32) (param $b i32) (result i32)
    local.get $a
    local.get $b
    i32.le_u)

  ;; Greater than or equal (signed)
  (func (export "ge_s") (param $a i32) (param $b i32) (result i32)
    local.get $a
    local.get $b
    i32.ge_s)

  (func (export "ge_s_same") (result i32)
    i32.const 42
    i32.const 42
    i32.ge_s)

  ;; Greater than or equal (unsigned)
  (func (export "ge_u") (param $a i32) (param $b i32) (result i32)
    local.get $a
    local.get $b
    i32.ge_u)
)
