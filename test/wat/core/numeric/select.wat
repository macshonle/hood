;; Test select instruction
(module
  ;; Basic select with i32
  (func (export "select_i32") (param $a i32) (param $b i32) (param $c i32) (result i32)
    local.get $a
    local.get $b
    local.get $c
    select)

  (func (export "select_i32_true") (result i32)
    i32.const 42
    i32.const 100
    i32.const 1
    select)

  (func (export "select_i32_false") (result i32)
    i32.const 42
    i32.const 100
    i32.const 0
    select)

  (func (export "select_i32_nonzero") (result i32)
    i32.const 42
    i32.const 100
    i32.const 5
    select)

  ;; Select with i64
  (func (export "select_i64") (param $a i64) (param $b i64) (param $c i32) (result i64)
    local.get $a
    local.get $b
    local.get $c
    select)

  (func (export "select_i64_true") (result i64)
    i64.const 42
    i64.const 100
    i32.const 1
    select)

  (func (export "select_i64_false") (result i64)
    i64.const 42
    i64.const 100
    i32.const 0
    select)

  ;; Select with f32
  (func (export "select_f32") (param $a f32) (param $b f32) (param $c i32) (result f32)
    local.get $a
    local.get $b
    local.get $c
    select)

  (func (export "select_f32_true") (result f32)
    f32.const 3.14
    f32.const 2.71
    i32.const 1
    select)

  ;; Select with f64
  (func (export "select_f64") (param $a f64) (param $b f64) (param $c i32) (result f64)
    local.get $a
    local.get $b
    local.get $c
    select)

  (func (export "select_f64_true") (result f64)
    f64.const 3.14159265358979
    f64.const 2.71828182845904
    i32.const 1
    select)

  ;; Typed select (MVP extension for multi-value)
  (func (export "select_typed_i32") (param $a i32) (param $b i32) (param $c i32) (result i32)
    local.get $a
    local.get $b
    local.get $c
    select (result i32))

  (func (export "select_typed_i64") (param $a i64) (param $b i64) (param $c i32) (result i64)
    local.get $a
    local.get $b
    local.get $c
    select (result i64))

  (func (export "select_typed_f32") (param $a f32) (param $b f32) (param $c i32) (result f32)
    local.get $a
    local.get $b
    local.get $c
    select (result f32))

  (func (export "select_typed_f64") (param $a f64) (param $b f64) (param $c i32) (result f64)
    local.get $a
    local.get $b
    local.get $c
    select (result f64))
)
