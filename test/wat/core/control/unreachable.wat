;; Test unreachable instruction
(module
  ;; unreachable at end (should trap)
  (func (export "unreachable_simple")
    unreachable)

  ;; unreachable after return (should trap if called)
  (func (export "unreachable_after_return") (result i32)
    i32.const 42
    return
    unreachable)  ;; never reached

  ;; unreachable in one branch
  (func (export "unreachable_in_branch") (param $x i32) (result i32)
    local.get $x
    i32.const 0
    i32.gt_s
    if (result i32)
      local.get $x
    else
      unreachable
    end)

  ;; unreachable after br
  (func (export "unreachable_after_br") (result i32)
    block (result i32)
      i32.const 42
      br 0
      unreachable
    end)

  ;; Type system allows anything after unreachable
  (func (export "unreachable_typing") (result i32)
    block (result i32)
      unreachable
      ;; After unreachable, type checker accepts any instruction
      ;; because this code is dead
    end)
)
