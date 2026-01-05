;; Test type conversion operations
(module
  ;; i32 wrap i64
  (func (export "i32_wrap_i64") (param $a i64) (result i32)
    local.get $a
    i32.wrap_i64)

  (func (export "i32_wrap_i64_small") (result i32)
    i64.const 42
    i32.wrap_i64)

  (func (export "i32_wrap_i64_large") (result i32)
    i64.const 0x123456789abcdef0
    i32.wrap_i64)

  ;; i64 extend i32 (signed)
  (func (export "i64_extend_i32_s") (param $a i32) (result i64)
    local.get $a
    i64.extend_i32_s)

  (func (export "i64_extend_i32_s_pos") (result i64)
    i32.const 42
    i64.extend_i32_s)

  (func (export "i64_extend_i32_s_neg") (result i64)
    i32.const -1
    i64.extend_i32_s)

  ;; i64 extend i32 (unsigned)
  (func (export "i64_extend_i32_u") (param $a i32) (result i64)
    local.get $a
    i64.extend_i32_u)

  (func (export "i64_extend_i32_u_neg") (result i64)
    i32.const -1
    i64.extend_i32_u)

  ;; i32 truncate f32 (signed)
  (func (export "i32_trunc_f32_s") (param $a f32) (result i32)
    local.get $a
    i32.trunc_f32_s)

  (func (export "i32_trunc_f32_s_const") (result i32)
    f32.const 42.7
    i32.trunc_f32_s)

  (func (export "i32_trunc_f32_s_neg") (result i32)
    f32.const -42.7
    i32.trunc_f32_s)

  ;; i32 truncate f32 (unsigned)
  (func (export "i32_trunc_f32_u") (param $a f32) (result i32)
    local.get $a
    i32.trunc_f32_u)

  ;; i32 truncate f64 (signed)
  (func (export "i32_trunc_f64_s") (param $a f64) (result i32)
    local.get $a
    i32.trunc_f64_s)

  ;; i32 truncate f64 (unsigned)
  (func (export "i32_trunc_f64_u") (param $a f64) (result i32)
    local.get $a
    i32.trunc_f64_u)

  ;; i64 truncate f32 (signed)
  (func (export "i64_trunc_f32_s") (param $a f32) (result i64)
    local.get $a
    i64.trunc_f32_s)

  ;; i64 truncate f32 (unsigned)
  (func (export "i64_trunc_f32_u") (param $a f32) (result i64)
    local.get $a
    i64.trunc_f32_u)

  ;; i64 truncate f64 (signed)
  (func (export "i64_trunc_f64_s") (param $a f64) (result i64)
    local.get $a
    i64.trunc_f64_s)

  (func (export "i64_trunc_f64_s_const") (result i64)
    f64.const 1234567890123.456
    i64.trunc_f64_s)

  ;; i64 truncate f64 (unsigned)
  (func (export "i64_trunc_f64_u") (param $a f64) (result i64)
    local.get $a
    i64.trunc_f64_u)

  ;; f32 convert i32 (signed)
  (func (export "f32_convert_i32_s") (param $a i32) (result f32)
    local.get $a
    f32.convert_i32_s)

  (func (export "f32_convert_i32_s_neg") (result f32)
    i32.const -1
    f32.convert_i32_s)

  ;; f32 convert i32 (unsigned)
  (func (export "f32_convert_i32_u") (param $a i32) (result f32)
    local.get $a
    f32.convert_i32_u)

  (func (export "f32_convert_i32_u_neg") (result f32)
    i32.const -1
    f32.convert_i32_u)

  ;; f32 convert i64 (signed)
  (func (export "f32_convert_i64_s") (param $a i64) (result f32)
    local.get $a
    f32.convert_i64_s)

  ;; f32 convert i64 (unsigned)
  (func (export "f32_convert_i64_u") (param $a i64) (result f32)
    local.get $a
    f32.convert_i64_u)

  ;; f64 convert i32 (signed)
  (func (export "f64_convert_i32_s") (param $a i32) (result f64)
    local.get $a
    f64.convert_i32_s)

  ;; f64 convert i32 (unsigned)
  (func (export "f64_convert_i32_u") (param $a i32) (result f64)
    local.get $a
    f64.convert_i32_u)

  ;; f64 convert i64 (signed)
  (func (export "f64_convert_i64_s") (param $a i64) (result f64)
    local.get $a
    f64.convert_i64_s)

  ;; f64 convert i64 (unsigned)
  (func (export "f64_convert_i64_u") (param $a i64) (result f64)
    local.get $a
    f64.convert_i64_u)

  ;; f32 demote f64
  (func (export "f32_demote_f64") (param $a f64) (result f32)
    local.get $a
    f32.demote_f64)

  (func (export "f32_demote_f64_const") (result f32)
    f64.const 3.14159265358979323846
    f32.demote_f64)

  ;; f64 promote f32
  (func (export "f64_promote_f32") (param $a f32) (result f64)
    local.get $a
    f64.promote_f32)

  (func (export "f64_promote_f32_const") (result f64)
    f32.const 3.14159
    f64.promote_f32)

  ;; Reinterpret operations
  (func (export "i32_reinterpret_f32") (param $a f32) (result i32)
    local.get $a
    i32.reinterpret_f32)

  (func (export "i64_reinterpret_f64") (param $a f64) (result i64)
    local.get $a
    i64.reinterpret_f64)

  (func (export "f32_reinterpret_i32") (param $a i32) (result f32)
    local.get $a
    f32.reinterpret_i32)

  (func (export "f64_reinterpret_i64") (param $a i64) (result f64)
    local.get $a
    f64.reinterpret_i64)
)
