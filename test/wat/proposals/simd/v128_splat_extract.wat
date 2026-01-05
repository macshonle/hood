;; Test SIMD splat and extract/replace lane operations
(module
  ;; Splat operations (fill all lanes with same value)
  (func (export "i8x16_splat") (param $x i32) (result v128)
    local.get $x
    i8x16.splat)

  (func (export "i16x8_splat") (param $x i32) (result v128)
    local.get $x
    i16x8.splat)

  (func (export "i32x4_splat") (param $x i32) (result v128)
    local.get $x
    i32x4.splat)

  (func (export "i64x2_splat") (param $x i64) (result v128)
    local.get $x
    i64x2.splat)

  (func (export "f32x4_splat") (param $x f32) (result v128)
    local.get $x
    f32x4.splat)

  (func (export "f64x2_splat") (param $x f64) (result v128)
    local.get $x
    f64x2.splat)

  ;; Extract lane operations
  (func (export "i8x16_extract_lane_s_0") (param $v v128) (result i32)
    local.get $v
    i8x16.extract_lane_s 0)

  (func (export "i8x16_extract_lane_s_15") (param $v v128) (result i32)
    local.get $v
    i8x16.extract_lane_s 15)

  (func (export "i8x16_extract_lane_u_0") (param $v v128) (result i32)
    local.get $v
    i8x16.extract_lane_u 0)

  (func (export "i16x8_extract_lane_s_0") (param $v v128) (result i32)
    local.get $v
    i16x8.extract_lane_s 0)

  (func (export "i16x8_extract_lane_u_7") (param $v v128) (result i32)
    local.get $v
    i16x8.extract_lane_u 7)

  (func (export "i32x4_extract_lane_0") (param $v v128) (result i32)
    local.get $v
    i32x4.extract_lane 0)

  (func (export "i32x4_extract_lane_3") (param $v v128) (result i32)
    local.get $v
    i32x4.extract_lane 3)

  (func (export "i64x2_extract_lane_0") (param $v v128) (result i64)
    local.get $v
    i64x2.extract_lane 0)

  (func (export "i64x2_extract_lane_1") (param $v v128) (result i64)
    local.get $v
    i64x2.extract_lane 1)

  (func (export "f32x4_extract_lane_0") (param $v v128) (result f32)
    local.get $v
    f32x4.extract_lane 0)

  (func (export "f32x4_extract_lane_3") (param $v v128) (result f32)
    local.get $v
    f32x4.extract_lane 3)

  (func (export "f64x2_extract_lane_0") (param $v v128) (result f64)
    local.get $v
    f64x2.extract_lane 0)

  (func (export "f64x2_extract_lane_1") (param $v v128) (result f64)
    local.get $v
    f64x2.extract_lane 1)

  ;; Replace lane operations
  (func (export "i8x16_replace_lane_0") (param $v v128) (param $x i32) (result v128)
    local.get $v
    local.get $x
    i8x16.replace_lane 0)

  (func (export "i16x8_replace_lane_0") (param $v v128) (param $x i32) (result v128)
    local.get $v
    local.get $x
    i16x8.replace_lane 0)

  (func (export "i32x4_replace_lane_0") (param $v v128) (param $x i32) (result v128)
    local.get $v
    local.get $x
    i32x4.replace_lane 0)

  (func (export "i64x2_replace_lane_0") (param $v v128) (param $x i64) (result v128)
    local.get $v
    local.get $x
    i64x2.replace_lane 0)

  (func (export "f32x4_replace_lane_0") (param $v v128) (param $x f32) (result v128)
    local.get $v
    local.get $x
    f32x4.replace_lane 0)

  (func (export "f64x2_replace_lane_0") (param $v v128) (param $x f64) (result v128)
    local.get $v
    local.get $x
    f64x2.replace_lane 0)
)
