;; Test loop control structure
(module
  ;; Simple loop (executes once, no branch back)
  (func (export "simple_loop") (result i32)
    (local $i i32)
    loop (result i32)
      i32.const 42
    end)

  ;; Loop with counter
  (func (export "count_to_10") (result i32)
    (local $i i32)
    block $done (result i32)
      loop $continue
        ;; Increment counter
        local.get $i
        i32.const 1
        i32.add
        local.set $i
        ;; Check if >= 10, then return
        local.get $i
        i32.const 10
        i32.ge_s
        if
          local.get $i
          br $done
        end
        ;; Continue loop
        br $continue
      end
      local.get $i
    end)

  ;; Factorial using loop
  (func (export "factorial") (param $n i32) (result i32)
    (local $result i32)
    (local $i i32)
    i32.const 1
    local.set $result
    i32.const 1
    local.set $i
    block $done
      loop $continue
        ;; if i > n, break
        local.get $i
        local.get $n
        i32.gt_s
        br_if $done
        ;; result = result * i
        local.get $result
        local.get $i
        i32.mul
        local.set $result
        ;; i++
        local.get $i
        i32.const 1
        i32.add
        local.set $i
        ;; continue loop
        br $continue
      end
    end
    local.get $result)

  ;; Sum 1 to n
  (func (export "sum_to_n") (param $n i32) (result i32)
    (local $sum i32)
    (local $i i32)
    i32.const 0
    local.set $sum
    i32.const 1
    local.set $i
    block $done
      loop $continue
        local.get $i
        local.get $n
        i32.gt_s
        br_if $done
        ;; sum += i
        local.get $sum
        local.get $i
        i32.add
        local.set $sum
        ;; i++
        local.get $i
        i32.const 1
        i32.add
        local.set $i
        br $continue
      end
    end
    local.get $sum)

  ;; Nested loops
  (func (export "nested_loops") (result i32)
    (local $outer i32)
    (local $inner i32)
    (local $sum i32)
    i32.const 0
    local.set $outer
    block $outer_done
      loop $outer_loop
        local.get $outer
        i32.const 3
        i32.ge_s
        br_if $outer_done
        ;; Inner loop
        i32.const 0
        local.set $inner
        block $inner_done
          loop $inner_loop
            local.get $inner
            i32.const 3
            i32.ge_s
            br_if $inner_done
            ;; sum++
            local.get $sum
            i32.const 1
            i32.add
            local.set $sum
            ;; inner++
            local.get $inner
            i32.const 1
            i32.add
            local.set $inner
            br $inner_loop
          end
        end
        ;; outer++
        local.get $outer
        i32.const 1
        i32.add
        local.set $outer
        br $outer_loop
      end
    end
    local.get $sum)

  ;; Loop with break condition inside
  (func (export "find_power_of_2") (param $target i32) (result i32)
    (local $power i32)
    i32.const 1
    local.set $power
    block $found
      loop $search
        local.get $power
        local.get $target
        i32.ge_s
        br_if $found
        local.get $power
        i32.const 2
        i32.mul
        local.set $power
        br $search
      end
    end
    local.get $power)
)
