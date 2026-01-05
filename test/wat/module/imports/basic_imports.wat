;; Test module imports
(module
  ;; Import function
  (import "env" "log_i32" (func $log_i32 (param i32)))
  (import "env" "log_i64" (func $log_i64 (param i64)))
  (import "env" "log_f32" (func $log_f32 (param f32)))
  (import "env" "log_f64" (func $log_f64 (param f64)))

  ;; Import function with result
  (import "env" "get_value" (func $get_value (result i32)))

  ;; Import function with params and result
  (import "env" "add" (func $imported_add (param i32 i32) (result i32)))

  ;; Import memory
  (import "env" "memory" (memory 1))

  ;; Import table
  (import "env" "table" (table 2 funcref))

  ;; Import global (immutable)
  (import "env" "const_value" (global $imported_const i32))

  ;; Import global (mutable)
  (import "env" "mut_value" (global $imported_mut (mut i32)))

  ;; Use imported function
  (func (export "call_log") (param $x i32)
    local.get $x
    call $log_i32)

  ;; Use imported function with result
  (func (export "use_get_value") (result i32)
    call $get_value)

  ;; Use imported add
  (func (export "use_imported_add") (param $a i32) (param $b i32) (result i32)
    local.get $a
    local.get $b
    call $imported_add)

  ;; Use imported global
  (func (export "get_imported_const") (result i32)
    global.get $imported_const)

  ;; Use imported mutable global
  (func (export "get_imported_mut") (result i32)
    global.get $imported_mut)

  (func (export "set_imported_mut") (param $x i32)
    local.get $x
    global.set $imported_mut)

  ;; Use imported memory
  (func (export "load_from_imported") (param $addr i32) (result i32)
    local.get $addr
    i32.load)

  (func (export "store_to_imported") (param $addr i32) (param $val i32)
    local.get $addr
    local.get $val
    i32.store)
)
