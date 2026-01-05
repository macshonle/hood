;; Test return instruction
(module
  ;; Simple return
  (func (export "return_void")
    return)

  ;; Return with value
  (func (export "return_i32") (result i32)
    i32.const 42
    return)

  ;; Return from nested blocks
  (func (export "return_nested") (result i32)
    block
      block
        i32.const 42
        return
      end
    end
    i32.const 100)  ;; unreachable

  ;; Return from loop
  (func (export "return_from_loop") (result i32)
    (local $i i32)
    loop
      local.get $i
      i32.const 1
      i32.add
      local.tee $i
      i32.const 5
      i32.eq
      if
        local.get $i
        return
      end
      br 0
    end
    i32.const 0)  ;; unreachable

  ;; Return from if
  (func (export "return_from_if") (param $cond i32) (result i32)
    local.get $cond
    if
      i32.const 1
      return
    end
    i32.const 0)

  ;; Return from if-else
  (func (export "early_return") (param $x i32) (result i32)
    local.get $x
    i32.const 0
    i32.lt_s
    if
      i32.const -1
      return
    end
    local.get $x
    i32.const 10
    i32.gt_s
    if
      i32.const 1
      return
    end
    i32.const 0)

  ;; Return i64
  (func (export "return_i64") (result i64)
    i64.const 0x123456789abcdef0
    return)

  ;; Return f32
  (func (export "return_f32") (result f32)
    f32.const 3.14159
    return)

  ;; Return f64
  (func (export "return_f64") (result f64)
    f64.const 2.718281828459045
    return)

  ;; Return multiple values (multi-value)
  (func (export "return_multi") (result i32 i32)
    i32.const 1
    i32.const 2
    return)

  ;; Guard clause pattern
  (func (export "guard_clause") (param $x i32) (result i32)
    ;; Guard: return early if x is 0
    local.get $x
    i32.eqz
    if
      i32.const 0
      return
    end
    ;; Guard: return early if x is negative
    local.get $x
    i32.const 0
    i32.lt_s
    if
      i32.const -1
      return
    end
    ;; Normal path
    local.get $x
    i32.const 2
    i32.mul)
)
