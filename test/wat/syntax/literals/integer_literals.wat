;; Test integer literal syntax
(module
  ;; Decimal
  (func (export "decimal_0") (result i32) i32.const 0)
  (func (export "decimal_1") (result i32) i32.const 1)
  (func (export "decimal_42") (result i32) i32.const 42)
  (func (export "decimal_max") (result i32) i32.const 2147483647)

  ;; Negative decimal
  (func (export "neg_1") (result i32) i32.const -1)
  (func (export "neg_42") (result i32) i32.const -42)
  (func (export "neg_min") (result i32) i32.const -2147483648)

  ;; Hexadecimal
  (func (export "hex_0") (result i32) i32.const 0x0)
  (func (export "hex_1") (result i32) i32.const 0x1)
  (func (export "hex_ff") (result i32) i32.const 0xff)
  (func (export "hex_FF") (result i32) i32.const 0xFF)
  (func (export "hex_mixed") (result i32) i32.const 0xDeAdBeEf)
  (func (export "hex_max") (result i32) i32.const 0xffffffff)

  ;; Negative hex
  (func (export "neg_hex") (result i32) i32.const -0x1)
  (func (export "neg_hex_ff") (result i32) i32.const -0xff)

  ;; With underscores (digit separators)
  (func (export "underscore_dec") (result i32) i32.const 1_000_000)
  (func (export "underscore_hex") (result i32) i32.const 0xdead_beef)
  (func (export "underscore_multi") (result i32) i32.const 1_000_000)

  ;; i64 literals
  (func (export "i64_small") (result i64) i64.const 42)
  (func (export "i64_large") (result i64) i64.const 9223372036854775807)
  (func (export "i64_neg") (result i64) i64.const -9223372036854775808)
  (func (export "i64_hex") (result i64) i64.const 0x123456789abcdef0)
  (func (export "i64_underscore") (result i64) i64.const 1_000_000_000_000)

  ;; Edge values
  (func (export "i32_min_signed") (result i32) i32.const 0x80000000)  ;; -2147483648
  (func (export "i32_max_signed") (result i32) i32.const 0x7fffffff)  ;; 2147483647
  (func (export "i64_min_signed") (result i64) i64.const 0x8000000000000000)
  (func (export "i64_max_signed") (result i64) i64.const 0x7fffffffffffffff)
)
