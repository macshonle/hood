;; Test float memory load/store operations
(module
  (memory 1)

  ;; f32 store and load
  (func (export "store_load_f32") (param $addr i32) (param $val f32) (result f32)
    local.get $addr
    local.get $val
    f32.store
    local.get $addr
    f32.load)

  (func (export "store_load_f32_const") (result f32)
    i32.const 0
    f32.const 3.14159
    f32.store
    i32.const 0
    f32.load)

  (func (export "store_load_f32_zero") (result f32)
    i32.const 0
    f32.const 0.0
    f32.store
    i32.const 0
    f32.load)

  (func (export "store_load_f32_neg_zero") (result f32)
    i32.const 0
    f32.const -0.0
    f32.store
    i32.const 0
    f32.load)

  (func (export "store_load_f32_inf") (result f32)
    i32.const 0
    f32.const inf
    f32.store
    i32.const 0
    f32.load)

  (func (export "store_load_f32_neg_inf") (result f32)
    i32.const 0
    f32.const -inf
    f32.store
    i32.const 0
    f32.load)

  ;; f64 store and load
  (func (export "store_load_f64") (param $addr i32) (param $val f64) (result f64)
    local.get $addr
    local.get $val
    f64.store
    local.get $addr
    f64.load)

  (func (export "store_load_f64_const") (result f64)
    i32.const 0
    f64.const 3.14159265358979
    f64.store
    i32.const 0
    f64.load)

  (func (export "store_load_f64_zero") (result f64)
    i32.const 0
    f64.const 0.0
    f64.store
    i32.const 0
    f64.load)

  (func (export "store_load_f64_neg_zero") (result f64)
    i32.const 0
    f64.const -0.0
    f64.store
    i32.const 0
    f64.load)

  (func (export "store_load_f64_inf") (result f64)
    i32.const 0
    f64.const inf
    f64.store
    i32.const 0
    f64.load)

  ;; Offset and alignment for f32
  (func (export "f32_offset_load") (result f32)
    i32.const 0
    f32.const 2.71828
    f32.store offset=4
    i32.const 0
    f32.load offset=4)

  (func (export "f32_aligned_load") (result f32)
    i32.const 0
    f32.const 1.41421
    f32.store align=4
    i32.const 0
    f32.load align=4)

  ;; Offset and alignment for f64
  (func (export "f64_offset_load") (result f64)
    i32.const 0
    f64.const 2.718281828459045
    f64.store offset=8
    i32.const 0
    f64.load offset=8)

  (func (export "f64_aligned_load") (result f64)
    i32.const 0
    f64.const 1.4142135623730951
    f64.store align=8
    i32.const 0
    f64.load align=8)
)
