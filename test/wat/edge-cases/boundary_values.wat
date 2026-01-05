;; Test boundary and edge case values
(module
  ;; i32 boundaries
  (func (export "i32_min") (result i32) i32.const -2147483648)
  (func (export "i32_max") (result i32) i32.const 2147483647)
  (func (export "i32_min_plus_1") (result i32) i32.const -2147483647)
  (func (export "i32_max_minus_1") (result i32) i32.const 2147483646)

  ;; i64 boundaries
  (func (export "i64_min") (result i64) i64.const -9223372036854775808)
  (func (export "i64_max") (result i64) i64.const 9223372036854775807)

  ;; Overflow behavior
  (func (export "i32_overflow_add") (result i32)
    i32.const 2147483647
    i32.const 1
    i32.add)  ;; wraps to -2147483648

  (func (export "i32_underflow_sub") (result i32)
    i32.const -2147483648
    i32.const 1
    i32.sub)  ;; wraps to 2147483647

  (func (export "i32_mul_overflow") (result i32)
    i32.const 65536
    i32.const 65536
    i32.mul)  ;; 0

  ;; f32 boundaries
  (func (export "f32_max") (result f32) f32.const 0x1.fffffep+127)
  (func (export "f32_min_positive") (result f32) f32.const 0x1p-126)
  (func (export "f32_min_subnormal") (result f32) f32.const 0x1p-149)

  ;; f64 boundaries
  (func (export "f64_max") (result f64) f64.const 0x1.fffffffffffffp+1023)
  (func (export "f64_min_positive") (result f64) f64.const 0x1p-1022)
  (func (export "f64_min_subnormal") (result f64) f64.const 0x1p-1074)

  ;; Shift edge cases
  (func (export "shl_by_0") (result i32)
    i32.const 1
    i32.const 0
    i32.shl)

  (func (export "shl_by_31") (result i32)
    i32.const 1
    i32.const 31
    i32.shl)

  (func (export "shl_by_32") (result i32)
    i32.const 1
    i32.const 32
    i32.shl)  ;; Wraps, equivalent to shl by 0

  (func (export "shl_by_33") (result i32)
    i32.const 1
    i32.const 33
    i32.shl)  ;; Wraps, equivalent to shl by 1

  ;; Division edge cases
  (func (export "div_by_1") (result i32)
    i32.const 42
    i32.const 1
    i32.div_s)

  (func (export "div_by_neg1") (result i32)
    i32.const 42
    i32.const -1
    i32.div_s)

  (func (export "rem_by_1") (result i32)
    i32.const 42
    i32.const 1
    i32.rem_s)

  ;; Zero comparisons
  (func (export "eq_zero_zero") (result i32)
    i32.const 0
    i32.const 0
    i32.eq)

  (func (export "lt_u_neg_1_vs_0") (result i32)
    i32.const -1  ;; 0xffffffff
    i32.const 0
    i32.lt_u)  ;; false (0xffffffff > 0)

  (func (export "lt_s_neg_1_vs_0") (result i32)
    i32.const -1
    i32.const 0
    i32.lt_s)  ;; true (-1 < 0)
)
