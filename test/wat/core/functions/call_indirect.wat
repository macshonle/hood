;; Test call_indirect (indirect function calls through table)
(module
  ;; Table for indirect calls
  (table 10 funcref)

  ;; Type definitions
  (type $int_to_int (func (param i32) (result i32)))
  (type $int_int_to_int (func (param i32 i32) (result i32)))
  (type $void_to_int (func (result i32)))

  ;; Functions with $int_to_int type
  (func $double (param $x i32) (result i32)
    local.get $x
    i32.const 2
    i32.mul)

  (func $triple (param $x i32) (result i32)
    local.get $x
    i32.const 3
    i32.mul)

  (func $inc (param $x i32) (result i32)
    local.get $x
    i32.const 1
    i32.add)

  (func $dec (param $x i32) (result i32)
    local.get $x
    i32.const 1
    i32.sub)

  (func $square (param $x i32) (result i32)
    local.get $x
    local.get $x
    i32.mul)

  ;; Functions with $int_int_to_int type
  (func $add (param $a i32) (param $b i32) (result i32)
    local.get $a
    local.get $b
    i32.add)

  (func $sub (param $a i32) (param $b i32) (result i32)
    local.get $a
    local.get $b
    i32.sub)

  (func $mul (param $a i32) (param $b i32) (result i32)
    local.get $a
    local.get $b
    i32.mul)

  ;; Functions with $void_to_int type
  (func $const42 (result i32) i32.const 42)
  (func $const100 (result i32) i32.const 100)

  ;; Initialize table
  (elem (i32.const 0) $double $triple $inc $dec $square $add $sub $mul $const42 $const100)

  ;; Call indirect with single param
  (func (export "call_unary") (param $func_idx i32) (param $x i32) (result i32)
    local.get $x
    local.get $func_idx
    call_indirect (type $int_to_int))

  ;; Call indirect with two params
  (func (export "call_binary") (param $func_idx i32) (param $a i32) (param $b i32) (result i32)
    local.get $a
    local.get $b
    local.get $func_idx
    call_indirect (type $int_int_to_int))

  ;; Call indirect with no params
  (func (export "call_nullary") (param $func_idx i32) (result i32)
    local.get $func_idx
    call_indirect (type $void_to_int))

  ;; Call specific functions through table
  (func (export "call_double") (param $x i32) (result i32)
    local.get $x
    i32.const 0  ;; $double is at index 0
    call_indirect (type $int_to_int))

  (func (export "call_triple") (param $x i32) (result i32)
    local.get $x
    i32.const 1  ;; $triple is at index 1
    call_indirect (type $int_to_int))

  (func (export "call_add") (param $a i32) (param $b i32) (result i32)
    local.get $a
    local.get $b
    i32.const 5  ;; $add is at index 5
    call_indirect (type $int_int_to_int))

  ;; Dynamic dispatch based on condition
  (func (export "dispatch") (param $use_double i32) (param $x i32) (result i32)
    local.get $x
    local.get $use_double
    if (result i32)
      i32.const 0  ;; double
    else
      i32.const 1  ;; triple
    end
    call_indirect (type $int_to_int))

  ;; Apply operation to array (simulated)
  (func (export "map_op") (param $op i32) (param $a i32) (param $b i32) (param $c i32) (result i32)
    ;; Apply $op to each of a, b, c and sum
    local.get $a
    local.get $op
    call_indirect (type $int_to_int)
    local.get $b
    local.get $op
    call_indirect (type $int_to_int)
    i32.add
    local.get $c
    local.get $op
    call_indirect (type $int_to_int)
    i32.add)
)
