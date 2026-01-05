;; Test br (branch) instruction
(module
  ;; br 0 exits innermost block
  (func (export "br_0") (result i32)
    block (result i32)
      i32.const 42
      br 0
    end)

  ;; br to outer block
  (func (export "br_outer") (result i32)
    block $outer (result i32)
      block $inner
        i32.const 42
        br $outer
      end
      i32.const 100  ;; unreachable
    end)

  ;; br with value through multiple blocks
  (func (export "br_multi_level") (result i32)
    block $a (result i32)
      block $b (result i32)
        block $c
          i32.const 42
          br $a
        end
        i32.const 1
      end
      i32.const 2
      i32.add
    end)

  ;; br from loop (exits loop)
  (func (export "br_from_loop") (result i32)
    (local $i i32)
    block $out (result i32)
      loop $loop
        local.get $i
        i32.const 1
        i32.add
        local.tee $i
        i32.const 5
        i32.eq
        if
          local.get $i
          br $out
        end
        br $loop
      end
      i32.const 0  ;; unreachable
    end)

  ;; br to loop (continues loop)
  (func (export "br_to_loop") (result i32)
    (local $i i32)
    block $done (result i32)
      loop $continue
        local.get $i
        i32.const 1
        i32.add
        local.tee $i
        i32.const 10
        i32.ge_s
        if
          local.get $i
          br $done
        end
        br $continue
      end
      i32.const 0
    end)

  ;; Numeric label references
  (func (export "br_numeric_labels") (result i32)
    block (result i32)        ;; label 2 from innermost
      block (result i32)      ;; label 1 from innermost
        block                 ;; label 0 from innermost
          i32.const 42
          br 2
        end
        i32.const 1
      end
    end)
)
