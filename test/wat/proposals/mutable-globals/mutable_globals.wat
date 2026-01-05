;; Test mutable globals (enabled by default in wabt)
(module
  ;; Immutable globals
  (global $const_i32 i32 (i32.const 42))
  (global $const_i64 i64 (i64.const 100))
  (global $const_f32 f32 (f32.const 3.14))
  (global $const_f64 f64 (f64.const 2.718))

  ;; Mutable globals
  (global $mut_i32 (mut i32) (i32.const 0))
  (global $mut_i64 (mut i64) (i64.const 0))
  (global $mut_f32 (mut f32) (f32.const 0.0))
  (global $mut_f64 (mut f64) (f64.const 0.0))

  ;; Read immutable
  (func (export "get_const_i32") (result i32)
    global.get $const_i32)

  (func (export "get_const_i64") (result i64)
    global.get $const_i64)

  (func (export "get_const_f32") (result f32)
    global.get $const_f32)

  (func (export "get_const_f64") (result f64)
    global.get $const_f64)

  ;; Read/write mutable i32
  (func (export "get_mut_i32") (result i32)
    global.get $mut_i32)

  (func (export "set_mut_i32") (param $val i32)
    local.get $val
    global.set $mut_i32)

  (func (export "inc_mut_i32") (result i32)
    global.get $mut_i32
    i32.const 1
    i32.add
    global.set $mut_i32
    global.get $mut_i32)

  ;; Read/write mutable i64
  (func (export "get_mut_i64") (result i64)
    global.get $mut_i64)

  (func (export "set_mut_i64") (param $val i64)
    local.get $val
    global.set $mut_i64)

  ;; Read/write mutable f32
  (func (export "get_mut_f32") (result f32)
    global.get $mut_f32)

  (func (export "set_mut_f32") (param $val f32)
    local.get $val
    global.set $mut_f32)

  ;; Read/write mutable f64
  (func (export "get_mut_f64") (result f64)
    global.get $mut_f64)

  (func (export "set_mut_f64") (param $val f64)
    local.get $val
    global.set $mut_f64)

  ;; Use global as accumulator
  (func (export "accumulate") (param $x i32) (result i32)
    global.get $mut_i32
    local.get $x
    i32.add
    global.set $mut_i32
    global.get $mut_i32)

  ;; Exported mutable global
  (global (export "exported_mut") (mut i32) (i32.const 0))

  ;; Exported immutable global
  (global (export "exported_const") i32 (i32.const 999))
)
