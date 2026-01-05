;; Test br_table (jump table) instruction
(module
  ;; Simple switch-like br_table
  (func (export "switch") (param $i i32) (result i32)
    block $default (result i32)
      block $case2 (result i32)
        block $case1 (result i32)
          block $case0 (result i32)
            i32.const 0  ;; placeholder result
            local.get $i
            br_table $case0 $case1 $case2 $default
          end
          drop
          i32.const 100  ;; case 0
          br $default
        end
        drop
        i32.const 101  ;; case 1
        br $default
      end
      drop
      i32.const 102  ;; case 2
    end)

  ;; br_table with out-of-range goes to default
  (func (export "switch_default") (param $i i32) (result i32)
    block $default (result i32)
      block $case0 (result i32)
        i32.const 0
        local.get $i
        br_table $case0 $default
      end
      drop
      i32.const 10  ;; case 0
      br $default
    end)

  ;; Test negative index (goes to default as unsigned)
  (func (export "switch_negative") (result i32)
    block $default (result i32)
      block $case0 (result i32)
        i32.const 0
        i32.const -1  ;; negative = large unsigned = default
        br_table $case0 $default
      end
      drop
      i32.const 10
      br $default
    end)

  ;; Multiple targets to same label
  (func (export "switch_multi_case") (param $i i32) (result i32)
    block $other (result i32)
      block $even (result i32)
        i32.const 0
        local.get $i
        ;; 0, 2, 4 -> $even; 1, 3 -> $other
        br_table $even $other $even $other $even $other
      end
      drop
      i32.const 1  ;; even
      br $other
    end)

  ;; Empty label list (only default)
  (func (export "switch_only_default") (param $i i32) (result i32)
    block $default (result i32)
      i32.const 42
      local.get $i
      br_table $default
    end)

  ;; Large table
  (func (export "switch_large") (param $i i32) (result i32)
    block $default (result i32)
      block $c9 (result i32)
        block $c8 (result i32)
          block $c7 (result i32)
            block $c6 (result i32)
              block $c5 (result i32)
                block $c4 (result i32)
                  block $c3 (result i32)
                    block $c2 (result i32)
                      block $c1 (result i32)
                        block $c0 (result i32)
                          i32.const 0
                          local.get $i
                          br_table $c0 $c1 $c2 $c3 $c4 $c5 $c6 $c7 $c8 $c9 $default
                        end
                        drop i32.const 0 br $default
                      end
                      drop i32.const 1 br $default
                    end
                    drop i32.const 2 br $default
                  end
                  drop i32.const 3 br $default
                end
                drop i32.const 4 br $default
              end
              drop i32.const 5 br $default
            end
            drop i32.const 6 br $default
          end
          drop i32.const 7 br $default
        end
        drop i32.const 8 br $default
      end
      drop i32.const 9
    end)
)
