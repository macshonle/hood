;; Test i32.const with various values
(module
  ;; Zero
  (func (export "zero") (result i32)
    i32.const 0)

  ;; Positive values
  (func (export "one") (result i32)
    i32.const 1)

  (func (export "max_signed") (result i32)
    i32.const 2147483647)

  (func (export "max_unsigned") (result i32)
    i32.const 4294967295)  ;; -1 in signed representation

  ;; Negative values
  (func (export "negative_one") (result i32)
    i32.const -1)

  (func (export "min_signed") (result i32)
    i32.const -2147483648)

  ;; Hex literals
  (func (export "hex_ff") (result i32)
    i32.const 0xff)

  (func (export "hex_deadbeef") (result i32)
    i32.const 0xdeadbeef)

  (func (export "hex_max") (result i32)
    i32.const 0xffffffff)

  ;; Underscore separators
  (func (export "with_underscores") (result i32)
    i32.const 1_000_000)

  (func (export "hex_with_underscores") (result i32)
    i32.const 0xdead_beef)

  ;; Powers of 2
  (func (export "pow2_16") (result i32)
    i32.const 65536)

  (func (export "pow2_31") (result i32)
    i32.const 0x80000000)
)
