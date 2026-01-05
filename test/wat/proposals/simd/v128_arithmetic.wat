;; Test SIMD arithmetic operations (enabled by default in wabt)
(module
  ;; i8x16 operations
  (func (export "i8x16_add") (param $a v128) (param $b v128) (result v128)
    local.get $a
    local.get $b
    i8x16.add)

  (func (export "i8x16_sub") (param $a v128) (param $b v128) (result v128)
    local.get $a
    local.get $b
    i8x16.sub)

  (func (export "i8x16_neg") (param $a v128) (result v128)
    local.get $a
    i8x16.neg)

  (func (export "i8x16_add_sat_s") (param $a v128) (param $b v128) (result v128)
    local.get $a
    local.get $b
    i8x16.add_sat_s)

  (func (export "i8x16_add_sat_u") (param $a v128) (param $b v128) (result v128)
    local.get $a
    local.get $b
    i8x16.add_sat_u)

  ;; i16x8 operations
  (func (export "i16x8_add") (param $a v128) (param $b v128) (result v128)
    local.get $a
    local.get $b
    i16x8.add)

  (func (export "i16x8_sub") (param $a v128) (param $b v128) (result v128)
    local.get $a
    local.get $b
    i16x8.sub)

  (func (export "i16x8_mul") (param $a v128) (param $b v128) (result v128)
    local.get $a
    local.get $b
    i16x8.mul)

  (func (export "i16x8_neg") (param $a v128) (result v128)
    local.get $a
    i16x8.neg)

  ;; i32x4 operations
  (func (export "i32x4_add") (param $a v128) (param $b v128) (result v128)
    local.get $a
    local.get $b
    i32x4.add)

  (func (export "i32x4_sub") (param $a v128) (param $b v128) (result v128)
    local.get $a
    local.get $b
    i32x4.sub)

  (func (export "i32x4_mul") (param $a v128) (param $b v128) (result v128)
    local.get $a
    local.get $b
    i32x4.mul)

  (func (export "i32x4_neg") (param $a v128) (result v128)
    local.get $a
    i32x4.neg)

  ;; i64x2 operations
  (func (export "i64x2_add") (param $a v128) (param $b v128) (result v128)
    local.get $a
    local.get $b
    i64x2.add)

  (func (export "i64x2_sub") (param $a v128) (param $b v128) (result v128)
    local.get $a
    local.get $b
    i64x2.sub)

  (func (export "i64x2_mul") (param $a v128) (param $b v128) (result v128)
    local.get $a
    local.get $b
    i64x2.mul)

  (func (export "i64x2_neg") (param $a v128) (result v128)
    local.get $a
    i64x2.neg)

  ;; f32x4 operations
  (func (export "f32x4_add") (param $a v128) (param $b v128) (result v128)
    local.get $a
    local.get $b
    f32x4.add)

  (func (export "f32x4_sub") (param $a v128) (param $b v128) (result v128)
    local.get $a
    local.get $b
    f32x4.sub)

  (func (export "f32x4_mul") (param $a v128) (param $b v128) (result v128)
    local.get $a
    local.get $b
    f32x4.mul)

  (func (export "f32x4_div") (param $a v128) (param $b v128) (result v128)
    local.get $a
    local.get $b
    f32x4.div)

  (func (export "f32x4_neg") (param $a v128) (result v128)
    local.get $a
    f32x4.neg)

  (func (export "f32x4_abs") (param $a v128) (result v128)
    local.get $a
    f32x4.abs)

  (func (export "f32x4_sqrt") (param $a v128) (result v128)
    local.get $a
    f32x4.sqrt)

  ;; f64x2 operations
  (func (export "f64x2_add") (param $a v128) (param $b v128) (result v128)
    local.get $a
    local.get $b
    f64x2.add)

  (func (export "f64x2_sub") (param $a v128) (param $b v128) (result v128)
    local.get $a
    local.get $b
    f64x2.sub)

  (func (export "f64x2_mul") (param $a v128) (param $b v128) (result v128)
    local.get $a
    local.get $b
    f64x2.mul)

  (func (export "f64x2_div") (param $a v128) (param $b v128) (result v128)
    local.get $a
    local.get $b
    f64x2.div)

  (func (export "f64x2_neg") (param $a v128) (result v128)
    local.get $a
    f64x2.neg)

  (func (export "f64x2_abs") (param $a v128) (result v128)
    local.get $a
    f64x2.abs)

  (func (export "f64x2_sqrt") (param $a v128) (result v128)
    local.get $a
    f64x2.sqrt)
)
