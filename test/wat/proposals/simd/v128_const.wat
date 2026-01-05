;; Test SIMD v128 constants (enabled by default in wabt)
(module
  ;; v128 constant with i8x16
  (func (export "const_i8x16") (result v128)
    v128.const i8x16 0 1 2 3 4 5 6 7 8 9 10 11 12 13 14 15)

  ;; v128 constant with i16x8
  (func (export "const_i16x8") (result v128)
    v128.const i16x8 0 1 2 3 4 5 6 7)

  ;; v128 constant with i32x4
  (func (export "const_i32x4") (result v128)
    v128.const i32x4 1 2 3 4)

  ;; v128 constant with i64x2
  (func (export "const_i64x2") (result v128)
    v128.const i64x2 100 200)

  ;; v128 constant with f32x4
  (func (export "const_f32x4") (result v128)
    v128.const f32x4 1.0 2.0 3.0 4.0)

  ;; v128 constant with f64x2
  (func (export "const_f64x2") (result v128)
    v128.const f64x2 1.5 2.5)

  ;; All zeros
  (func (export "const_zeros") (result v128)
    v128.const i32x4 0 0 0 0)

  ;; All ones (0xffffffff...)
  (func (export "const_all_ones") (result v128)
    v128.const i32x4 -1 -1 -1 -1)

  ;; Hex values
  (func (export "const_hex") (result v128)
    v128.const i32x4 0xdeadbeef 0xcafebabe 0x12345678 0x87654321)

  ;; Negative values
  (func (export "const_neg_i8x16") (result v128)
    v128.const i8x16 -1 -2 -3 -4 -5 -6 -7 -8 -9 -10 -11 -12 -13 -14 -15 -16)

  (func (export "const_neg_i16x8") (result v128)
    v128.const i16x8 -100 -200 -300 -400 -500 -600 -700 -800)

  (func (export "const_neg_i32x4") (result v128)
    v128.const i32x4 -1000 -2000 -3000 -4000)

  (func (export "const_neg_i64x2") (result v128)
    v128.const i64x2 -1000000 -2000000)

  ;; Special float values
  (func (export "const_f32x4_special") (result v128)
    v128.const f32x4 0.0 -0.0 inf -inf)

  (func (export "const_f64x2_inf") (result v128)
    v128.const f64x2 inf -inf)
)
