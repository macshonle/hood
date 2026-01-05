;; Test basic function definitions
(module
  ;; Function with no params, no result
  (func (export "void_func"))

  ;; Function with no params, i32 result
  (func (export "const_42") (result i32)
    i32.const 42)

  ;; Function with one param
  (func (export "identity") (param $x i32) (result i32)
    local.get $x)

  ;; Function with multiple params
  (func (export "add") (param $a i32) (param $b i32) (result i32)
    local.get $a
    local.get $b
    i32.add)

  ;; Function with params declared together
  (func (export "add_together") (param i32 i32) (result i32)
    local.get 0
    local.get 1
    i32.add)

  ;; Function with locals
  (func (export "with_local") (param $x i32) (result i32)
    (local $temp i32)
    local.get $x
    i32.const 10
    i32.add
    local.set $temp
    local.get $temp)

  ;; Function with multiple locals
  (func (export "with_locals") (param $x i32) (result i32)
    (local $a i32)
    (local $b i32)
    (local $c i32)
    local.get $x
    local.set $a
    local.get $a
    i32.const 2
    i32.mul
    local.set $b
    local.get $b
    i32.const 1
    i32.add
    local.set $c
    local.get $c)

  ;; Function with locals declared together
  (func (export "locals_together") (result i32)
    (local i32 i32 i32)
    i32.const 1
    local.set 0
    i32.const 2
    local.set 1
    i32.const 3
    local.set 2
    local.get 0
    local.get 1
    i32.add
    local.get 2
    i32.add)

  ;; local.tee (set and return value)
  (func (export "local_tee") (param $x i32) (result i32)
    (local $temp i32)
    local.get $x
    i32.const 5
    i32.add
    local.tee $temp
    local.get $temp
    i32.add)

  ;; Multiple return values
  (func (export "multi_return") (result i32 i32)
    i32.const 1
    i32.const 2)

  ;; Three return values
  (func (export "triple_return") (result i32 i32 i32)
    i32.const 1
    i32.const 2
    i32.const 3)

  ;; Different types of returns
  (func (export "mixed_return") (result i32 i64 f32)
    i32.const 42
    i64.const 100
    f32.const 3.14)

  ;; Function with i64 param and result
  (func (export "identity_i64") (param $x i64) (result i64)
    local.get $x)

  ;; Function with f32 param and result
  (func (export "identity_f32") (param $x f32) (result f32)
    local.get $x)

  ;; Function with f64 param and result
  (func (export "identity_f64") (param $x f64) (result f64)
    local.get $x)

  ;; Mixed parameter types
  (func (export "mixed_params") (param $a i32) (param $b i64) (param $c f32) (param $d f64) (result i32)
    local.get $a)
)
