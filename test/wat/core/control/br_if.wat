;; Test br_if (conditional branch) instruction
(module
  ;; br_if with true condition
  (func (export "br_if_true") (result i32)
    block (result i32)
      i32.const 42
      i32.const 1  ;; true
      br_if 0
      drop
      i32.const 100
    end)

  ;; br_if with false condition
  (func (export "br_if_false") (result i32)
    block (result i32)
      i32.const 42
      i32.const 0  ;; false
      br_if 0
      drop
      i32.const 100
    end)

  ;; br_if with non-zero (truthy)
  (func (export "br_if_nonzero") (result i32)
    block (result i32)
      i32.const 42
      i32.const 5  ;; non-zero = true
      br_if 0
      drop
      i32.const 100
    end)

  ;; br_if with comparison
  (func (export "br_if_lt") (param $a i32) (param $b i32) (result i32)
    block (result i32)
      i32.const 1  ;; assume true
      local.get $a
      local.get $b
      i32.lt_s
      br_if 0
      drop
      i32.const 0  ;; was false
    end)

  ;; br_if in loop
  (func (export "count_loop") (param $n i32) (result i32)
    (local $i i32)
    block $done (result i32)
      loop $continue
        ;; i++
        local.get $i
        i32.const 1
        i32.add
        local.tee $i
        ;; if i >= n, return i
        local.get $n
        i32.ge_s
        if
          local.get $i
          br $done
        end
        br $continue
      end
      i32.const 0
    end)

  ;; Nested br_if
  (func (export "nested_br_if") (param $x i32) (result i32)
    block $outer (result i32)
      block $inner (result i32)
        i32.const 0
        local.get $x
        i32.const 10
        i32.gt_s
        br_if $outer
        drop
        i32.const 1
        local.get $x
        i32.const 5
        i32.gt_s
        br_if $inner
        drop
        i32.const 2
      end
    end)

  ;; br_if with side effects (value not consumed if branch not taken)
  (func (export "br_if_stack") (result i32)
    (local $x i32)
    block (result i32)
      i32.const 100
      i32.const 0
      br_if 0  ;; branch not taken, 100 stays on stack but br_if consumes it
      drop
      i32.const 50
    end)
)
