;; Test if control structure
(module
  ;; Simple if (no else, no result)
  (func (export "if_true") (result i32)
    (local $x i32)
    i32.const 1
    if
      i32.const 42
      local.set $x
    end
    local.get $x)

  (func (export "if_false") (result i32)
    (local $x i32)
    i32.const 0
    if
      i32.const 42
      local.set $x
    end
    local.get $x)

  ;; If-else with result
  (func (export "if_else_true") (result i32)
    i32.const 1
    if (result i32)
      i32.const 42
    else
      i32.const 100
    end)

  (func (export "if_else_false") (result i32)
    i32.const 0
    if (result i32)
      i32.const 42
    else
      i32.const 100
    end)

  ;; If with comparison
  (func (export "max") (param $a i32) (param $b i32) (result i32)
    local.get $a
    local.get $b
    i32.gt_s
    if (result i32)
      local.get $a
    else
      local.get $b
    end)

  (func (export "min") (param $a i32) (param $b i32) (result i32)
    local.get $a
    local.get $b
    i32.lt_s
    if (result i32)
      local.get $a
    else
      local.get $b
    end)

  ;; Nested if
  (func (export "nested_if") (param $x i32) (result i32)
    local.get $x
    i32.const 0
    i32.gt_s
    if (result i32)
      local.get $x
      i32.const 10
      i32.gt_s
      if (result i32)
        i32.const 2  ;; x > 10
      else
        i32.const 1  ;; 0 < x <= 10
      end
    else
      i32.const 0  ;; x <= 0
    end)

  ;; If-else chain (like else-if)
  (func (export "classify") (param $x i32) (result i32)
    local.get $x
    i32.const 0
    i32.lt_s
    if (result i32)
      i32.const -1  ;; negative
    else
      local.get $x
      i32.const 0
      i32.eq
      if (result i32)
        i32.const 0  ;; zero
      else
        i32.const 1  ;; positive
      end
    end)

  ;; If with br
  (func (export "if_with_br") (param $x i32) (result i32)
    block $out (result i32)
      local.get $x
      i32.const 5
      i32.gt_s
      if
        i32.const 100
        br $out
      end
      i32.const 50
    end)

  ;; If with multiple values (multi-value)
  (func (export "if_multi") (param $cond i32) (result i32 i32)
    local.get $cond
    if (result i32 i32)
      i32.const 1
      i32.const 2
    else
      i32.const 3
      i32.const 4
    end)

  ;; Absolute value using if
  (func (export "abs") (param $x i32) (result i32)
    local.get $x
    i32.const 0
    i32.lt_s
    if (result i32)
      i32.const 0
      local.get $x
      i32.sub
    else
      local.get $x
    end)

  ;; Sign function
  (func (export "sign") (param $x i32) (result i32)
    local.get $x
    i32.const 0
    i32.gt_s
    if (result i32)
      i32.const 1
    else
      local.get $x
      i32.const 0
      i32.lt_s
      if (result i32)
        i32.const -1
      else
        i32.const 0
      end
    end)
)
