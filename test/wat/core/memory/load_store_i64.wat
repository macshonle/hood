;; Test i64 memory load/store operations
(module
  (memory 1)

  ;; i64.store and i64.load
  (func (export "store_load_i64") (param $addr i32) (param $val i64) (result i64)
    local.get $addr
    local.get $val
    i64.store
    local.get $addr
    i64.load)

  (func (export "store_load_i64_const") (result i64)
    i32.const 0
    i64.const 0xdeadbeefcafebabe
    i64.store
    i32.const 0
    i64.load)

  ;; i64.store8 and i64.load8_s
  (func (export "store8_load8_s") (param $addr i32) (param $val i64) (result i64)
    local.get $addr
    local.get $val
    i64.store8
    local.get $addr
    i64.load8_s)

  (func (export "load8_s_neg") (result i64)
    i32.const 0
    i64.const 0xff
    i64.store8
    i32.const 0
    i64.load8_s)

  ;; i64.store8 and i64.load8_u
  (func (export "store8_load8_u") (param $addr i32) (param $val i64) (result i64)
    local.get $addr
    local.get $val
    i64.store8
    local.get $addr
    i64.load8_u)

  ;; i64.store16 and i64.load16_s
  (func (export "store16_load16_s") (param $addr i32) (param $val i64) (result i64)
    local.get $addr
    local.get $val
    i64.store16
    local.get $addr
    i64.load16_s)

  (func (export "load16_s_neg") (result i64)
    i32.const 0
    i64.const 0xffff
    i64.store16
    i32.const 0
    i64.load16_s)

  ;; i64.store16 and i64.load16_u
  (func (export "store16_load16_u") (param $addr i32) (param $val i64) (result i64)
    local.get $addr
    local.get $val
    i64.store16
    local.get $addr
    i64.load16_u)

  ;; i64.store32 and i64.load32_s
  (func (export "store32_load32_s") (param $addr i32) (param $val i64) (result i64)
    local.get $addr
    local.get $val
    i64.store32
    local.get $addr
    i64.load32_s)

  (func (export "load32_s_neg") (result i64)
    i32.const 0
    i64.const 0xffffffff
    i64.store32
    i32.const 0
    i64.load32_s)

  ;; i64.store32 and i64.load32_u
  (func (export "store32_load32_u") (param $addr i32) (param $val i64) (result i64)
    local.get $addr
    local.get $val
    i64.store32
    local.get $addr
    i64.load32_u)

  (func (export "load32_u_neg") (result i64)
    i32.const 0
    i64.const 0xffffffff
    i64.store32
    i32.const 0
    i64.load32_u)

  ;; Offset addressing
  (func (export "offset_load") (result i64)
    i32.const 0
    i64.const 0x123456789abcdef0
    i64.store offset=8
    i32.const 0
    i64.load offset=8)

  ;; Alignment
  (func (export "aligned_load") (result i64)
    i32.const 0
    i64.const 0x123456789abcdef0
    i64.store align=8
    i32.const 0
    i64.load align=8)

  (func (export "unaligned_load") (result i64)
    i32.const 1
    i64.const 0x123456789abcdef0
    i64.store align=1
    i32.const 1
    i64.load align=1)
)
