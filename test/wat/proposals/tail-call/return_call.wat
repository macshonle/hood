;; Test tail call proposal (requires --enable-tail-call)
;; return_call performs a tail call to a function
(module
  ;; Simple tail call
  (func $add (param $a i32) (param $b i32) (result i32)
    local.get $a
    local.get $b
    i32.add)

  (func (export "tail_call_add") (param $a i32) (param $b i32) (result i32)
    local.get $a
    local.get $b
    return_call $add)

  ;; Tail call chain
  (func $f1 (param $x i32) (result i32)
    local.get $x
    i32.const 1
    i32.add)

  (func $f2 (param $x i32) (result i32)
    local.get $x
    return_call $f1)

  (func (export "chain") (param $x i32) (result i32)
    local.get $x
    return_call $f2)

  ;; Tail recursive factorial
  (func $factorial_tail (param $n i32) (param $acc i32) (result i32)
    local.get $n
    i32.const 1
    i32.le_s
    if (result i32)
      local.get $acc
    else
      local.get $n
      i32.const 1
      i32.sub
      local.get $n
      local.get $acc
      i32.mul
      return_call $factorial_tail
    end)

  (func (export "factorial") (param $n i32) (result i32)
    local.get $n
    i32.const 1
    return_call $factorial_tail)

  ;; Tail recursive sum
  (func $sum_tail (param $n i32) (param $acc i32) (result i32)
    local.get $n
    i32.const 0
    i32.le_s
    if (result i32)
      local.get $acc
    else
      local.get $n
      i32.const 1
      i32.sub
      local.get $acc
      local.get $n
      i32.add
      return_call $sum_tail
    end)

  (func (export "sum_to_n") (param $n i32) (result i32)
    local.get $n
    i32.const 0
    return_call $sum_tail)

  ;; Mutually tail-recursive even/odd
  (func $even_tail (param $n i32) (result i32)
    local.get $n
    i32.eqz
    if (result i32)
      i32.const 1
    else
      local.get $n
      i32.const 1
      i32.sub
      return_call $odd_tail
    end)

  (func $odd_tail (param $n i32) (result i32)
    local.get $n
    i32.eqz
    if (result i32)
      i32.const 0
    else
      local.get $n
      i32.const 1
      i32.sub
      return_call $even_tail
    end)

  (func (export "is_even") (param $n i32) (result i32)
    local.get $n
    return_call $even_tail)

  (func (export "is_odd") (param $n i32) (result i32)
    local.get $n
    return_call $odd_tail)
)
