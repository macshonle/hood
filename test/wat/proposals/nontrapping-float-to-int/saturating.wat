;; Test non-trapping float-to-int conversions (enabled by default in wabt)
;; These are "saturating" conversions that clamp out-of-range values
(module
  ;; i32.trunc_sat_f32_s
  (func (export "i32_trunc_sat_f32_s") (param $x f32) (result i32)
    local.get $x
    i32.trunc_sat_f32_s)

  (func (export "i32_trunc_sat_f32_s_normal") (result i32)
    f32.const 42.7
    i32.trunc_sat_f32_s)

  (func (export "i32_trunc_sat_f32_s_large") (result i32)
    f32.const 3e9  ;; Larger than i32 max
    i32.trunc_sat_f32_s)  ;; Should return i32.max

  (func (export "i32_trunc_sat_f32_s_neg_large") (result i32)
    f32.const -3e9  ;; Smaller than i32 min
    i32.trunc_sat_f32_s)  ;; Should return i32.min

  (func (export "i32_trunc_sat_f32_s_nan") (result i32)
    f32.const nan
    i32.trunc_sat_f32_s)  ;; Should return 0

  (func (export "i32_trunc_sat_f32_s_inf") (result i32)
    f32.const inf
    i32.trunc_sat_f32_s)  ;; Should return i32.max

  (func (export "i32_trunc_sat_f32_s_neg_inf") (result i32)
    f32.const -inf
    i32.trunc_sat_f32_s)  ;; Should return i32.min

  ;; i32.trunc_sat_f32_u
  (func (export "i32_trunc_sat_f32_u") (param $x f32) (result i32)
    local.get $x
    i32.trunc_sat_f32_u)

  (func (export "i32_trunc_sat_f32_u_large") (result i32)
    f32.const 5e9
    i32.trunc_sat_f32_u)  ;; Should return u32.max

  (func (export "i32_trunc_sat_f32_u_neg") (result i32)
    f32.const -1.0
    i32.trunc_sat_f32_u)  ;; Should return 0

  ;; i32.trunc_sat_f64_s
  (func (export "i32_trunc_sat_f64_s") (param $x f64) (result i32)
    local.get $x
    i32.trunc_sat_f64_s)

  (func (export "i32_trunc_sat_f64_s_large") (result i32)
    f64.const 3e10
    i32.trunc_sat_f64_s)

  (func (export "i32_trunc_sat_f64_s_nan") (result i32)
    f64.const nan
    i32.trunc_sat_f64_s)

  ;; i32.trunc_sat_f64_u
  (func (export "i32_trunc_sat_f64_u") (param $x f64) (result i32)
    local.get $x
    i32.trunc_sat_f64_u)

  ;; i64.trunc_sat_f32_s
  (func (export "i64_trunc_sat_f32_s") (param $x f32) (result i64)
    local.get $x
    i64.trunc_sat_f32_s)

  (func (export "i64_trunc_sat_f32_s_large") (result i64)
    f32.const 1e20
    i64.trunc_sat_f32_s)

  (func (export "i64_trunc_sat_f32_s_nan") (result i64)
    f32.const nan
    i64.trunc_sat_f32_s)

  ;; i64.trunc_sat_f32_u
  (func (export "i64_trunc_sat_f32_u") (param $x f32) (result i64)
    local.get $x
    i64.trunc_sat_f32_u)

  ;; i64.trunc_sat_f64_s
  (func (export "i64_trunc_sat_f64_s") (param $x f64) (result i64)
    local.get $x
    i64.trunc_sat_f64_s)

  (func (export "i64_trunc_sat_f64_s_large") (result i64)
    f64.const 1e20
    i64.trunc_sat_f64_s)

  (func (export "i64_trunc_sat_f64_s_nan") (result i64)
    f64.const nan
    i64.trunc_sat_f64_s)

  (func (export "i64_trunc_sat_f64_s_inf") (result i64)
    f64.const inf
    i64.trunc_sat_f64_s)

  ;; i64.trunc_sat_f64_u
  (func (export "i64_trunc_sat_f64_u") (param $x f64) (result i64)
    local.get $x
    i64.trunc_sat_f64_u)

  (func (export "i64_trunc_sat_f64_u_neg") (result i64)
    f64.const -1.0
    i64.trunc_sat_f64_u)
)
