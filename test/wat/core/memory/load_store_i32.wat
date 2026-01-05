;; Test i32 memory load/store operations
(module
  (memory 1)

  ;; i32.store and i32.load
  (func (export "store_load_i32") (param $addr i32) (param $val i32) (result i32)
    local.get $addr
    local.get $val
    i32.store
    local.get $addr
    i32.load)

  (func (export "store_load_i32_const") (result i32)
    i32.const 0
    i32.const 0xdeadbeef
    i32.store
    i32.const 0
    i32.load)

  ;; i32.store8 and i32.load8_s
  (func (export "store8_load8_s") (param $addr i32) (param $val i32) (result i32)
    local.get $addr
    local.get $val
    i32.store8
    local.get $addr
    i32.load8_s)

  (func (export "load8_s_neg") (result i32)
    i32.const 0
    i32.const 0xff
    i32.store8
    i32.const 0
    i32.load8_s)

  ;; i32.store8 and i32.load8_u
  (func (export "store8_load8_u") (param $addr i32) (param $val i32) (result i32)
    local.get $addr
    local.get $val
    i32.store8
    local.get $addr
    i32.load8_u)

  (func (export "load8_u_neg") (result i32)
    i32.const 0
    i32.const 0xff
    i32.store8
    i32.const 0
    i32.load8_u)

  ;; i32.store16 and i32.load16_s
  (func (export "store16_load16_s") (param $addr i32) (param $val i32) (result i32)
    local.get $addr
    local.get $val
    i32.store16
    local.get $addr
    i32.load16_s)

  (func (export "load16_s_neg") (result i32)
    i32.const 0
    i32.const 0xffff
    i32.store16
    i32.const 0
    i32.load16_s)

  ;; i32.store16 and i32.load16_u
  (func (export "store16_load16_u") (param $addr i32) (param $val i32) (result i32)
    local.get $addr
    local.get $val
    i32.store16
    local.get $addr
    i32.load16_u)

  (func (export "load16_u_neg") (result i32)
    i32.const 0
    i32.const 0xffff
    i32.store16
    i32.const 0
    i32.load16_u)

  ;; Alignment tests (default alignment)
  (func (export "aligned_load") (result i32)
    i32.const 0
    i32.const 0x12345678
    i32.store
    i32.const 0
    i32.load)

  ;; Explicit alignment
  (func (export "aligned_load_explicit") (result i32)
    i32.const 0
    i32.const 0x12345678
    i32.store align=4
    i32.const 0
    i32.load align=4)

  ;; Unaligned access (alignment hint smaller than natural)
  (func (export "unaligned_load") (result i32)
    i32.const 1
    i32.const 0x12345678
    i32.store align=1
    i32.const 1
    i32.load align=1)

  ;; Offset addressing
  (func (export "offset_load") (result i32)
    i32.const 0
    i32.const 0xaabbccdd
    i32.store offset=4
    i32.const 0
    i32.load offset=4)

  (func (export "offset_store_load") (param $base i32) (param $val i32) (result i32)
    local.get $base
    local.get $val
    i32.store offset=16
    local.get $base
    i32.load offset=16)

  ;; Combined offset and alignment
  (func (export "offset_aligned_load") (result i32)
    i32.const 0
    i32.const 0x11223344
    i32.store offset=8 align=4
    i32.const 0
    i32.load offset=8 align=4)
)
