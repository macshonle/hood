;; Test SIMD bitwise and logical operations
(module
  ;; v128 bitwise operations
  (func (export "v128_and") (param $a v128) (param $b v128) (result v128)
    local.get $a
    local.get $b
    v128.and)

  (func (export "v128_or") (param $a v128) (param $b v128) (result v128)
    local.get $a
    local.get $b
    v128.or)

  (func (export "v128_xor") (param $a v128) (param $b v128) (result v128)
    local.get $a
    local.get $b
    v128.xor)

  (func (export "v128_not") (param $a v128) (result v128)
    local.get $a
    v128.not)

  (func (export "v128_andnot") (param $a v128) (param $b v128) (result v128)
    local.get $a
    local.get $b
    v128.andnot)

  ;; v128 bit select (conditional per bit)
  (func (export "v128_bitselect") (param $a v128) (param $b v128) (param $c v128) (result v128)
    local.get $a
    local.get $b
    local.get $c
    v128.bitselect)

  ;; v128 any_true (at least one bit is 1)
  (func (export "v128_any_true") (param $a v128) (result i32)
    local.get $a
    v128.any_true)

  (func (export "v128_any_true_zeros") (result i32)
    v128.const i32x4 0 0 0 0
    v128.any_true)

  (func (export "v128_any_true_one") (result i32)
    v128.const i32x4 0 0 0 1
    v128.any_true)

  ;; i8x16 all_true
  (func (export "i8x16_all_true") (param $a v128) (result i32)
    local.get $a
    i8x16.all_true)

  ;; i16x8 all_true
  (func (export "i16x8_all_true") (param $a v128) (result i32)
    local.get $a
    i16x8.all_true)

  ;; i32x4 all_true
  (func (export "i32x4_all_true") (param $a v128) (result i32)
    local.get $a
    i32x4.all_true)

  ;; i64x2 all_true
  (func (export "i64x2_all_true") (param $a v128) (result i32)
    local.get $a
    i64x2.all_true)

  ;; Shift operations
  (func (export "i8x16_shl") (param $a v128) (param $b i32) (result v128)
    local.get $a
    local.get $b
    i8x16.shl)

  (func (export "i8x16_shr_s") (param $a v128) (param $b i32) (result v128)
    local.get $a
    local.get $b
    i8x16.shr_s)

  (func (export "i8x16_shr_u") (param $a v128) (param $b i32) (result v128)
    local.get $a
    local.get $b
    i8x16.shr_u)

  (func (export "i16x8_shl") (param $a v128) (param $b i32) (result v128)
    local.get $a
    local.get $b
    i16x8.shl)

  (func (export "i16x8_shr_s") (param $a v128) (param $b i32) (result v128)
    local.get $a
    local.get $b
    i16x8.shr_s)

  (func (export "i16x8_shr_u") (param $a v128) (param $b i32) (result v128)
    local.get $a
    local.get $b
    i16x8.shr_u)

  (func (export "i32x4_shl") (param $a v128) (param $b i32) (result v128)
    local.get $a
    local.get $b
    i32x4.shl)

  (func (export "i32x4_shr_s") (param $a v128) (param $b i32) (result v128)
    local.get $a
    local.get $b
    i32x4.shr_s)

  (func (export "i32x4_shr_u") (param $a v128) (param $b i32) (result v128)
    local.get $a
    local.get $b
    i32x4.shr_u)

  (func (export "i64x2_shl") (param $a v128) (param $b i32) (result v128)
    local.get $a
    local.get $b
    i64x2.shl)

  (func (export "i64x2_shr_s") (param $a v128) (param $b i32) (result v128)
    local.get $a
    local.get $b
    i64x2.shr_s)

  (func (export "i64x2_shr_u") (param $a v128) (param $b i32) (result v128)
    local.get $a
    local.get $b
    i64x2.shr_u)
)
