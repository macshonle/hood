;; Test return_call_indirect (requires --enable-tail-call)
(module
  (table 10 funcref)

  (type $int_to_int (func (param i32) (result i32)))

  (func $double (param $x i32) (result i32)
    local.get $x
    i32.const 2
    i32.mul)

  (func $triple (param $x i32) (result i32)
    local.get $x
    i32.const 3
    i32.mul)

  (func $square (param $x i32) (result i32)
    local.get $x
    local.get $x
    i32.mul)

  (elem (i32.const 0) $double $triple $square)

  ;; Tail call indirect
  (func (export "dispatch") (param $op i32) (param $x i32) (result i32)
    local.get $x
    local.get $op
    return_call_indirect (type $int_to_int))

  ;; Chain of indirect tail calls
  (func $apply_and_continue (param $x i32) (result i32)
    local.get $x
    i32.const 10
    i32.lt_s
    if (result i32)
      ;; Apply double and continue
      local.get $x
      i32.const 0  ;; $double
      return_call_indirect (type $int_to_int)
    else
      local.get $x
    end)

  (func (export "iterate_double") (param $x i32) (result i32)
    local.get $x
    return_call $apply_and_continue)

  ;; Trampoline pattern
  (type $cont (func (result i32)))

  (func $bounce (result i32)
    i32.const 42)

  (elem (i32.const 5) $bounce)

  (func (export "trampoline") (result i32)
    i32.const 5
    return_call_indirect (type $cont))
)
