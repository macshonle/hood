;; Test function references proposal (requires --enable-function-references)
(module
  ;; Type definitions with name
  (type $i32_to_i32 (func (param i32) (result i32)))
  (type $binary_op (func (param i32 i32) (result i32)))

  ;; Declare functions that will be used with ref.func
  ;; (required by the spec - functions must be in an elem segment to use ref.func)
  (elem declare func $double $triple)

  ;; Functions matching the types
  (func $double (type $i32_to_i32) (param $x i32) (result i32)
    local.get $x
    i32.const 2
    i32.mul)

  (func $triple (type $i32_to_i32) (param $x i32) (result i32)
    local.get $x
    i32.const 3
    i32.mul)

  (func $add (type $binary_op) (param $a i32) (param $b i32) (result i32)
    local.get $a
    local.get $b
    i32.add)

  (func $sub (type $binary_op) (param $a i32) (param $b i32) (result i32)
    local.get $a
    local.get $b
    i32.sub)

  ;; call_ref - call through typed function reference
  (func (export "call_double") (param $x i32) (result i32)
    local.get $x
    ref.func $double
    call_ref $i32_to_i32)

  (func (export "call_triple") (param $x i32) (result i32)
    local.get $x
    ref.func $triple
    call_ref $i32_to_i32)

  ;; Pass function reference as parameter
  (func $apply (param $x i32) (param $f (ref $i32_to_i32)) (result i32)
    local.get $x
    local.get $f
    call_ref $i32_to_i32)

  (func (export "apply_double") (param $x i32) (result i32)
    local.get $x
    ref.func $double
    call $apply)

  (func (export "apply_triple") (param $x i32) (result i32)
    local.get $x
    ref.func $triple
    call $apply)

  ;; Higher-order function
  (func $compose (param $x i32) (param $f (ref $i32_to_i32)) (param $g (ref $i32_to_i32)) (result i32)
    local.get $x
    local.get $f
    call_ref $i32_to_i32
    local.get $g
    call_ref $i32_to_i32)

  (func (export "double_then_triple") (param $x i32) (result i32)
    local.get $x
    ref.func $double
    ref.func $triple
    call $compose)

  ;; Nullable function reference
  (func (export "nullable_ref") (param $use_double i32) (result i32)
    (local $f (ref null $i32_to_i32))
    local.get $use_double
    if
      ref.func $double
      local.set $f
    else
      ref.func $triple
      local.set $f
    end
    i32.const 10
    local.get $f
    call_ref $i32_to_i32)

  ;; ref.null with typed references
  (func (export "null_func_ref") (result (ref null $i32_to_i32))
    ref.null $i32_to_i32)

  ;; ref.is_null with typed references
  (func (export "is_null_ref") (param $f (ref null $i32_to_i32)) (result i32)
    local.get $f
    ref.is_null)

  ;; br_on_null
  (func (export "br_on_null_test") (param $f (ref null $i32_to_i32)) (result i32)
    block $null (result i32)
      i32.const 5
      local.get $f
      br_on_null $null
      call_ref $i32_to_i32
      return
    end
    ;; Reached if $f was null, stack has i32
    drop
    i32.const -1)
)
