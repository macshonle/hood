;; Test i64.const with various values
(module
  ;; Zero
  (func (export "zero") (result i64)
    i64.const 0)

  ;; Positive values
  (func (export "one") (result i64)
    i64.const 1)

  (func (export "max_signed") (result i64)
    i64.const 9223372036854775807)

  (func (export "max_unsigned") (result i64)
    i64.const 18446744073709551615)  ;; -1 in signed representation

  ;; Negative values
  (func (export "negative_one") (result i64)
    i64.const -1)

  (func (export "min_signed") (result i64)
    i64.const -9223372036854775808)

  ;; Hex literals
  (func (export "hex_ff") (result i64)
    i64.const 0xff)

  (func (export "hex_large") (result i64)
    i64.const 0xdeadbeefcafebabe)

  (func (export "hex_max") (result i64)
    i64.const 0xffffffffffffffff)

  ;; Underscore separators
  (func (export "with_underscores") (result i64)
    i64.const 1_000_000_000_000)

  (func (export "hex_with_underscores") (result i64)
    i64.const 0xdead_beef_cafe_babe)

  ;; Powers of 2
  (func (export "pow2_32") (result i64)
    i64.const 4294967296)

  (func (export "pow2_63") (result i64)
    i64.const 0x8000000000000000)

  ;; Values larger than i32
  (func (export "large_positive") (result i64)
    i64.const 1099511627776)  ;; 2^40

  (func (export "i32_max_plus_one") (result i64)
    i64.const 4294967296)
)
