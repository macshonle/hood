;; Test multi-value proposal (enabled by default in wabt)
(module
  ;; Function returning multiple values
  (func (export "pair") (result i32 i32)
    i32.const 1
    i32.const 2)

  (func (export "triple") (result i32 i32 i32)
    i32.const 1
    i32.const 2
    i32.const 3)

  ;; Mixed types
  (func (export "mixed_pair") (result i32 i64)
    i32.const 42
    i64.const 100)

  (func (export "all_types") (result i32 i64 f32 f64)
    i32.const 1
    i64.const 2
    f32.const 3.0
    f64.const 4.0)

  ;; Block with multiple results
  (func (export "block_multi") (result i32 i32)
    block (result i32 i32)
      i32.const 10
      i32.const 20
    end)

  ;; If with multiple results
  (func (export "if_multi") (param $cond i32) (result i32 i32)
    local.get $cond
    if (result i32 i32)
      i32.const 1
      i32.const 2
    else
      i32.const 3
      i32.const 4
    end)

  ;; Loop with multiple params and results
  (func (export "loop_multi") (result i32 i32)
    (local $a i32)
    (local $b i32)
    i32.const 0
    local.set $a
    i32.const 0
    local.set $b
    block $done (result i32 i32)
      loop $continue
        ;; Increment a
        local.get $a
        i32.const 1
        i32.add
        local.set $a
        ;; Increment b by 10
        local.get $b
        i32.const 10
        i32.add
        local.set $b
        ;; Check if a < 5, continue loop
        local.get $a
        i32.const 5
        i32.lt_s
        br_if $continue
      end
      ;; Return both values
      local.get $a
      local.get $b
    end)

  ;; Use multi-value return in computation
  (func $divmod (param $a i32) (param $b i32) (result i32 i32)
    local.get $a
    local.get $b
    i32.div_s
    local.get $a
    local.get $b
    i32.rem_s)

  (func (export "divmod_sum") (param $a i32) (param $b i32) (result i32)
    local.get $a
    local.get $b
    call $divmod
    i32.add)

  ;; Swap using multi-value
  (func (export "swap") (param $a i32) (param $b i32) (result i32 i32)
    local.get $b
    local.get $a)

  ;; Nested multi-value blocks
  (func (export "nested_multi") (result i32 i32 i32)
    block (result i32 i32 i32)
      block (result i32 i32)
        i32.const 1
        i32.const 2
      end
      i32.const 3
    end)

  ;; Branch with multiple values
  (func (export "br_multi") (param $x i32) (result i32 i32)
    block $out (result i32 i32)
      local.get $x
      i32.const 0
      i32.gt_s
      if
        i32.const 1
        i32.const 2
        br $out
      end
      i32.const 3
      i32.const 4
    end)
)
