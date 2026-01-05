;; Test SIMD memory operations
(module
  (memory 1)

  ;; Initialize some test data
  (data (i32.const 0) "\00\01\02\03\04\05\06\07\08\09\0a\0b\0c\0d\0e\0f")
  (data (i32.const 16) "\10\11\12\13\14\15\16\17\18\19\1a\1b\1c\1d\1e\1f")

  ;; v128.load
  (func (export "v128_load") (param $addr i32) (result v128)
    local.get $addr
    v128.load)

  ;; v128.store
  (func (export "v128_store") (param $addr i32) (param $v v128)
    local.get $addr
    local.get $v
    v128.store)

  ;; Load and return
  (func (export "load_at_0") (result v128)
    i32.const 0
    v128.load)

  ;; Store and load back
  (func (export "store_load") (result v128)
    i32.const 100
    v128.const i32x4 1 2 3 4
    v128.store
    i32.const 100
    v128.load)

  ;; Load with offset
  (func (export "load_offset") (result v128)
    i32.const 0
    v128.load offset=16)

  ;; Store with offset
  (func (export "store_offset") (result v128)
    i32.const 0
    v128.const i32x4 0xaabbccdd 0x11223344 0x55667788 0x99aabbcc
    v128.store offset=200
    i32.const 0
    v128.load offset=200)

  ;; Load splat operations (load scalar and splat to all lanes)
  (func (export "v128_load8_splat") (param $addr i32) (result v128)
    local.get $addr
    v128.load8_splat)

  (func (export "v128_load16_splat") (param $addr i32) (result v128)
    local.get $addr
    v128.load16_splat)

  (func (export "v128_load32_splat") (param $addr i32) (result v128)
    local.get $addr
    v128.load32_splat)

  (func (export "v128_load64_splat") (param $addr i32) (result v128)
    local.get $addr
    v128.load64_splat)

  ;; Load zero (load and zero-extend)
  (func (export "v128_load32_zero") (param $addr i32) (result v128)
    local.get $addr
    v128.load32_zero)

  (func (export "v128_load64_zero") (param $addr i32) (result v128)
    local.get $addr
    v128.load64_zero)

  ;; Load lane (load into specific lane)
  (func (export "v128_load8_lane") (param $addr i32) (param $v v128) (result v128)
    local.get $addr
    local.get $v
    v128.load8_lane 0)

  (func (export "v128_load16_lane") (param $addr i32) (param $v v128) (result v128)
    local.get $addr
    local.get $v
    v128.load16_lane 0)

  (func (export "v128_load32_lane") (param $addr i32) (param $v v128) (result v128)
    local.get $addr
    local.get $v
    v128.load32_lane 0)

  (func (export "v128_load64_lane") (param $addr i32) (param $v v128) (result v128)
    local.get $addr
    local.get $v
    v128.load64_lane 0)

  ;; Store lane (store from specific lane)
  (func (export "v128_store8_lane") (param $addr i32) (param $v v128)
    local.get $addr
    local.get $v
    v128.store8_lane 0)

  (func (export "v128_store16_lane") (param $addr i32) (param $v v128)
    local.get $addr
    local.get $v
    v128.store16_lane 0)

  (func (export "v128_store32_lane") (param $addr i32) (param $v v128)
    local.get $addr
    local.get $v
    v128.store32_lane 0)

  (func (export "v128_store64_lane") (param $addr i32) (param $v v128)
    local.get $addr
    local.get $v
    v128.store64_lane 0)
)
