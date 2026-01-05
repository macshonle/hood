;; Test extended constant expressions proposal (requires --enable-extended-const)
;; Allows arithmetic operations (add, sub, mul) in constant expressions
;; Note: Can only reference imported globals, not local ones
(module
  ;; Import globals to use in constant expressions
  (import "env" "base" (global $base i32))
  (import "env" "offset" (global $offset i32))
  (import "env" "base64" (global $base64 i64))
  (import "env" "data_base" (global $data_base i32))

  ;; i32.add in global initialization (referencing imported globals)
  (global $sum i32 (i32.add (global.get $base) (global.get $offset)))

  ;; i32.sub in global initialization
  (global $diff i32 (i32.sub (global.get $base) (global.get $offset)))

  ;; i32.mul in global initialization
  (global $product i32 (i32.mul (global.get $base) (i32.const 2)))

  ;; i64 operations with imported global
  (global $sum64 i64 (i64.add (global.get $base64) (i64.const 234)))
  (global $mul64 i64 (i64.mul (global.get $base64) (i64.const 10)))

  ;; Nested expressions
  (global $complex i32 (i32.add
    (i32.mul (global.get $base) (i32.const 2))
    (global.get $offset)))

  ;; Memory with computed offset in data segment
  (memory (export "memory") 1)
  (data (i32.add (global.get $data_base) (i32.const 0)) "Hello")
  (data (i32.add (global.get $data_base) (i32.const 10)) "World")

  ;; Read computed globals
  (func (export "get_sum") (result i32)
    global.get $sum)

  (func (export "get_diff") (result i32)
    global.get $diff)

  (func (export "get_product") (result i32)
    global.get $product)

  (func (export "get_sum64") (result i64)
    global.get $sum64)

  (func (export "get_mul64") (result i64)
    global.get $mul64)

  (func (export "get_complex") (result i32)
    global.get $complex)

  (func (export "read_at_base") (result i32)
    global.get $data_base
    i32.load8_u)

  (func (export "read_at_base_plus_10") (result i32)
    global.get $data_base
    i32.const 10
    i32.add
    i32.load8_u)
)
