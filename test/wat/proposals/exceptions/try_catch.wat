;; Test exception handling proposal (requires --enable-exceptions)
(module
  ;; Exception tags
  (tag $e1 (param i32))
  (tag $e2 (param i32 i64))
  (tag $e_empty)

  ;; Simple throw
  (func (export "throw_e1") (param $x i32)
    local.get $x
    throw $e1)

  ;; Throw empty exception
  (func (export "throw_empty")
    throw $e_empty)

  ;; Try-catch block
  (func (export "catch_e1") (param $throw i32) (result i32)
    try (result i32)
      local.get $throw
      if
        i32.const 42
        throw $e1
      end
      i32.const 0
    catch $e1
      ;; Caught value is on stack
      i32.const 100
      i32.add
    end)

  ;; Multiple catch clauses
  (func (export "multi_catch") (param $which i32) (result i32)
    try (result i32)
      local.get $which
      i32.const 1
      i32.eq
      if
        i32.const 10
        throw $e1
      end
      local.get $which
      i32.const 2
      i32.eq
      if
        throw $e_empty
      end
      i32.const 0
    catch $e1
      i32.const 1
      i32.add  ;; Return caught value + 1
    catch $e_empty
      i32.const 999
    end)

  ;; catch_all
  (func (export "catch_all") (param $throw i32) (result i32)
    try (result i32)
      local.get $throw
      if
        i32.const 42
        throw $e1
      end
      i32.const 0
    catch_all
      i32.const -1
    end)

  ;; Nested try blocks
  (func (export "nested_try") (result i32)
    try (result i32)
      try (result i32)
        i32.const 1
        throw $e1
      catch $e1
        i32.const 10
        i32.add
        throw $e1
      end
    catch $e1
      i32.const 100
      i32.add
    end)

  ;; rethrow
  (func (export "rethrow_test") (result i32)
    try (result i32)
      try (result i32)
        i32.const 5
        throw $e1
      catch $e1
        ;; Value is on stack, rethrow the exception
        rethrow 0
      end
    catch $e1
      ;; Caught after rethrow
      i32.const 1000
      i32.add
    end)

  ;; Function that may throw
  (func $maybe_throw (param $x i32) (result i32)
    local.get $x
    i32.const 0
    i32.lt_s
    if
      local.get $x
      throw $e1
    end
    local.get $x
    i32.const 2
    i32.mul)

  (func (export "call_maybe_throw") (param $x i32) (result i32)
    try (result i32)
      local.get $x
      call $maybe_throw
    catch $e1
      ;; Return caught (negative) value
    end)
)
