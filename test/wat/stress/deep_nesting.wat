;; Test deep nesting of blocks and control structures
(module
  ;; Deep block nesting
  (func (export "deep_blocks") (result i32)
    block (result i32)
      block (result i32)
        block (result i32)
          block (result i32)
            block (result i32)
              block (result i32)
                block (result i32)
                  block (result i32)
                    block (result i32)
                      block (result i32)
                        i32.const 42
                      end
                    end
                  end
                end
              end
            end
          end
        end
      end
    end)

  ;; Deep if nesting
  (func (export "deep_if") (param $depth i32) (result i32)
    local.get $depth
    i32.const 1
    i32.gt_s
    if (result i32)
      local.get $depth
      i32.const 2
      i32.gt_s
      if (result i32)
        local.get $depth
        i32.const 3
        i32.gt_s
        if (result i32)
          local.get $depth
          i32.const 4
          i32.gt_s
          if (result i32)
            local.get $depth
            i32.const 5
            i32.gt_s
            if (result i32)
              i32.const 5
            else
              i32.const 4
            end
          else
            i32.const 3
          end
        else
          i32.const 2
        end
      else
        i32.const 1
      end
    else
      i32.const 0
    end)

  ;; Deep loop nesting with br
  (func (export "deep_loop") (result i32)
    (local $sum i32)
    block $b0 (result i32)
      loop $l0
        loop $l1
          loop $l2
            loop $l3
              local.get $sum
              i32.const 1
              i32.add
              local.set $sum
              local.get $sum
              i32.const 100
              i32.lt_s
              br_if $l3
            end
          end
        end
      end
      local.get $sum
    end)

  ;; Many sequential blocks
  (func (export "many_blocks") (result i32)
    (local $sum i32)
    block local.get $sum i32.const 1 i32.add local.set $sum end
    block local.get $sum i32.const 1 i32.add local.set $sum end
    block local.get $sum i32.const 1 i32.add local.set $sum end
    block local.get $sum i32.const 1 i32.add local.set $sum end
    block local.get $sum i32.const 1 i32.add local.set $sum end
    block local.get $sum i32.const 1 i32.add local.set $sum end
    block local.get $sum i32.const 1 i32.add local.set $sum end
    block local.get $sum i32.const 1 i32.add local.set $sum end
    block local.get $sum i32.const 1 i32.add local.set $sum end
    block local.get $sum i32.const 1 i32.add local.set $sum end
    local.get $sum)

  ;; Deeply nested S-expressions
  (func (export "deep_sexp") (result i32)
    (i32.add
      (i32.add
        (i32.add
          (i32.add
            (i32.add
              (i32.add
                (i32.add
                  (i32.add
                    (i32.add
                      (i32.add
                        (i32.const 1)
                        (i32.const 2))
                      (i32.const 3))
                    (i32.const 4))
                  (i32.const 5))
                (i32.const 6))
              (i32.const 7))
            (i32.const 8))
          (i32.const 9))
        (i32.const 10))
      (i32.const 11)))
)
