;; Test relaxed SIMD proposal (requires --enable-relaxed-simd)
;; These operations have implementation-defined behavior for some inputs
(module
  ;; Relaxed swizzle (may differ from i8x16.swizzle for out-of-range indices)
  (func (export "i8x16_relaxed_swizzle") (param $v v128) (param $s v128) (result v128)
    local.get $v
    local.get $s
    i8x16.relaxed_swizzle)

  ;; Relaxed truncation (saturating behavior may differ)
  (func (export "i32x4_relaxed_trunc_f32x4_s") (param $v v128) (result v128)
    local.get $v
    i32x4.relaxed_trunc_f32x4_s)

  (func (export "i32x4_relaxed_trunc_f32x4_u") (param $v v128) (result v128)
    local.get $v
    i32x4.relaxed_trunc_f32x4_u)

  (func (export "i32x4_relaxed_trunc_f64x2_s_zero") (param $v v128) (result v128)
    local.get $v
    i32x4.relaxed_trunc_f64x2_s_zero)

  (func (export "i32x4_relaxed_trunc_f64x2_u_zero") (param $v v128) (result v128)
    local.get $v
    i32x4.relaxed_trunc_f64x2_u_zero)

  ;; Relaxed fused multiply-add (may or may not be fused)
  (func (export "f32x4_relaxed_madd") (param $a v128) (param $b v128) (param $c v128) (result v128)
    local.get $a
    local.get $b
    local.get $c
    f32x4.relaxed_madd)

  (func (export "f32x4_relaxed_nmadd") (param $a v128) (param $b v128) (param $c v128) (result v128)
    local.get $a
    local.get $b
    local.get $c
    f32x4.relaxed_nmadd)

  (func (export "f64x2_relaxed_madd") (param $a v128) (param $b v128) (param $c v128) (result v128)
    local.get $a
    local.get $b
    local.get $c
    f64x2.relaxed_madd)

  (func (export "f64x2_relaxed_nmadd") (param $a v128) (param $b v128) (param $c v128) (result v128)
    local.get $a
    local.get $b
    local.get $c
    f64x2.relaxed_nmadd)

  ;; Relaxed lane select
  (func (export "i8x16_relaxed_laneselect") (param $a v128) (param $b v128) (param $m v128) (result v128)
    local.get $a
    local.get $b
    local.get $m
    i8x16.relaxed_laneselect)

  (func (export "i16x8_relaxed_laneselect") (param $a v128) (param $b v128) (param $m v128) (result v128)
    local.get $a
    local.get $b
    local.get $m
    i16x8.relaxed_laneselect)

  (func (export "i32x4_relaxed_laneselect") (param $a v128) (param $b v128) (param $m v128) (result v128)
    local.get $a
    local.get $b
    local.get $m
    i32x4.relaxed_laneselect)

  (func (export "i64x2_relaxed_laneselect") (param $a v128) (param $b v128) (param $m v128) (result v128)
    local.get $a
    local.get $b
    local.get $m
    i64x2.relaxed_laneselect)

  ;; Relaxed min/max
  (func (export "f32x4_relaxed_min") (param $a v128) (param $b v128) (result v128)
    local.get $a
    local.get $b
    f32x4.relaxed_min)

  (func (export "f32x4_relaxed_max") (param $a v128) (param $b v128) (result v128)
    local.get $a
    local.get $b
    f32x4.relaxed_max)

  (func (export "f64x2_relaxed_min") (param $a v128) (param $b v128) (result v128)
    local.get $a
    local.get $b
    f64x2.relaxed_min)

  (func (export "f64x2_relaxed_max") (param $a v128) (param $b v128) (result v128)
    local.get $a
    local.get $b
    f64x2.relaxed_max)

  ;; Relaxed q15mulr
  (func (export "i16x8_relaxed_q15mulr_s") (param $a v128) (param $b v128) (result v128)
    local.get $a
    local.get $b
    i16x8.relaxed_q15mulr_s)

  ;; Relaxed dot product
  (func (export "i16x8_relaxed_dot_i8x16_i7x16_s") (param $a v128) (param $b v128) (result v128)
    local.get $a
    local.get $b
    i16x8.relaxed_dot_i8x16_i7x16_s)

  (func (export "i32x4_relaxed_dot_i8x16_i7x16_add_s") (param $a v128) (param $b v128) (param $c v128) (result v128)
    local.get $a
    local.get $b
    local.get $c
    i32x4.relaxed_dot_i8x16_i7x16_add_s)
)
