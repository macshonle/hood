;; Test block control structure
(module
  ;; Simple block (void)
  (func (export "empty_block")
    block
    end)

  ;; Block with result
  (func (export "block_result") (result i32)
    block (result i32)
      i32.const 42
    end)

  ;; Nested blocks
  (func (export "nested_blocks") (result i32)
    block (result i32)
      block (result i32)
        i32.const 1
      end
      i32.const 2
      i32.add
    end)

  ;; Block with label (named)
  (func (export "named_block") (result i32)
    block $outer (result i32)
      block $inner (result i32)
        i32.const 10
      end
      i32.const 5
      i32.add
    end)

  ;; Block with br (branch)
  (func (export "block_br") (result i32)
    block (result i32)
      i32.const 42
      br 0
      i32.const 100  ;; unreachable
    end)

  ;; Nested block with br
  (func (export "nested_block_br") (result i32)
    block $outer (result i32)
      block (result i32)
        i32.const 42
        br $outer
        i32.const 100  ;; unreachable
      end
      i32.const 50
      i32.add  ;; unreachable
    end)

  ;; Block with br_if
  (func (export "block_br_if_true") (result i32)
    block (result i32)
      i32.const 42
      i32.const 1  ;; true condition
      br_if 0
      drop
      i32.const 100
    end)

  (func (export "block_br_if_false") (result i32)
    block (result i32)
      i32.const 42
      i32.const 0  ;; false condition
      br_if 0
      drop
      i32.const 100
    end)

  ;; Deeply nested blocks
  (func (export "deep_nesting") (result i32)
    block (result i32)
      block (result i32)
        block (result i32)
          block (result i32)
            i32.const 1
          end
          i32.const 2
          i32.add
        end
        i32.const 3
        i32.add
      end
      i32.const 4
      i32.add
    end)

  ;; Block with multiple values (multi-value)
  (func (export "block_multi") (result i32 i32)
    block (result i32 i32)
      i32.const 1
      i32.const 2
    end)
)
