;; Test global variables
(module
  ;; Immutable globals
  (global $const_i32 i32 (i32.const 42))
  (global $const_i64 i64 (i64.const 0x123456789abcdef0))
  (global $const_f32 f32 (f32.const 3.14159))
  (global $const_f64 f64 (f64.const 2.718281828459045))

  ;; Mutable globals (mutable-globals proposal, enabled by default)
  (global $mut_i32 (mut i32) (i32.const 0))
  (global $mut_i64 (mut i64) (i64.const 0))
  (global $mut_f32 (mut f32) (f32.const 0.0))
  (global $mut_f64 (mut f64) (f64.const 0.0))

  ;; Get immutable globals
  (func (export "get_const_i32") (result i32)
    global.get $const_i32)

  (func (export "get_const_i64") (result i64)
    global.get $const_i64)

  (func (export "get_const_f32") (result f32)
    global.get $const_f32)

  (func (export "get_const_f64") (result f64)
    global.get $const_f64)

  ;; Get mutable globals (initial value)
  (func (export "get_mut_i32") (result i32)
    global.get $mut_i32)

  ;; Set and get mutable globals
  (func (export "set_get_i32") (param $val i32) (result i32)
    local.get $val
    global.set $mut_i32
    global.get $mut_i32)

  (func (export "set_get_i64") (param $val i64) (result i64)
    local.get $val
    global.set $mut_i64
    global.get $mut_i64)

  (func (export "set_get_f32") (param $val f32) (result f32)
    local.get $val
    global.set $mut_f32
    global.get $mut_f32)

  (func (export "set_get_f64") (param $val f64) (result f64)
    local.get $val
    global.set $mut_f64
    global.get $mut_f64)

  ;; Global counter
  (func (export "increment") (result i32)
    global.get $mut_i32
    i32.const 1
    i32.add
    global.set $mut_i32
    global.get $mut_i32)

  ;; Use global in computation
  (func (export "add_to_global") (param $x i32) (result i32)
    global.get $const_i32
    local.get $x
    i32.add)

  ;; Multiple global accesses
  (func (export "swap_globals") (result i32)
    (local $temp i32)
    global.get $mut_i32
    local.set $temp
    global.get $const_i32
    global.set $mut_i32
    local.get $temp)

  ;; Global by index
  (func (export "get_global_by_index") (result i32)
    global.get 0)

  ;; Note: Referencing local globals in initializers requires extended-const proposal
  ;; See proposals/extended-const/ for those tests
)
