;; Test function calls
(module
  ;; Internal helper functions
  (func $add (param $a i32) (param $b i32) (result i32)
    local.get $a
    local.get $b
    i32.add)

  (func $mul (param $a i32) (param $b i32) (result i32)
    local.get $a
    local.get $b
    i32.mul)

  (func $square (param $x i32) (result i32)
    local.get $x
    local.get $x
    i32.mul)

  (func $inc (param $x i32) (result i32)
    local.get $x
    i32.const 1
    i32.add)

  ;; Call internal function
  (func (export "call_add") (result i32)
    i32.const 3
    i32.const 4
    call $add)

  ;; Call with parameters from caller
  (func (export "call_add_params") (param $a i32) (param $b i32) (result i32)
    local.get $a
    local.get $b
    call $add)

  ;; Call chain
  (func (export "call_chain") (param $x i32) (result i32)
    local.get $x
    call $inc
    call $square)

  ;; Multiple calls
  (func (export "call_multiple") (result i32)
    i32.const 2
    call $square  ;; 4
    i32.const 3
    call $square  ;; 9
    call $add)    ;; 13

  ;; Call by index
  (func (export "call_by_index") (result i32)
    i32.const 5
    i32.const 6
    call 0)  ;; calls $add

  ;; Recursive function
  (func $factorial (export "factorial") (param $n i32) (result i32)
    local.get $n
    i32.const 1
    i32.le_s
    if (result i32)
      i32.const 1
    else
      local.get $n
      local.get $n
      i32.const 1
      i32.sub
      call $factorial
      i32.mul
    end)

  ;; Fibonacci (recursive)
  (func $fib (export "fib") (param $n i32) (result i32)
    local.get $n
    i32.const 2
    i32.lt_s
    if (result i32)
      local.get $n
    else
      local.get $n
      i32.const 1
      i32.sub
      call $fib
      local.get $n
      i32.const 2
      i32.sub
      call $fib
      i32.add
    end)

  ;; Mutually recursive
  (func $even (export "is_even") (param $n i32) (result i32)
    local.get $n
    i32.eqz
    if (result i32)
      i32.const 1
    else
      local.get $n
      i32.const 1
      i32.sub
      call $odd
    end)

  (func $odd (export "is_odd") (param $n i32) (result i32)
    local.get $n
    i32.eqz
    if (result i32)
      i32.const 0
    else
      local.get $n
      i32.const 1
      i32.sub
      call $even
    end)

  ;; Call with multi-value return
  (func $pair (result i32 i32)
    i32.const 10
    i32.const 20)

  (func (export "use_pair") (result i32)
    call $pair
    i32.add)
)
