;; Test i32 bitwise operations
(module
  ;; AND
  (func (export "and") (param $a i32) (param $b i32) (result i32)
    local.get $a
    local.get $b
    i32.and)

  (func (export "and_zero") (result i32)
    i32.const 0xffffffff
    i32.const 0
    i32.and)

  (func (export "and_mask") (result i32)
    i32.const 0xdeadbeef
    i32.const 0xff00ff00
    i32.and)

  ;; OR
  (func (export "or") (param $a i32) (param $b i32) (result i32)
    local.get $a
    local.get $b
    i32.or)

  (func (export "or_zero") (result i32)
    i32.const 0xdeadbeef
    i32.const 0
    i32.or)

  (func (export "or_all") (result i32)
    i32.const 0xf0f0f0f0
    i32.const 0x0f0f0f0f
    i32.or)

  ;; XOR
  (func (export "xor") (param $a i32) (param $b i32) (result i32)
    local.get $a
    local.get $b
    i32.xor)

  (func (export "xor_self") (result i32)
    i32.const 12345
    i32.const 12345
    i32.xor)

  (func (export "xor_invert") (result i32)
    i32.const 0xdeadbeef
    i32.const 0xffffffff
    i32.xor)

  ;; Shift left
  (func (export "shl") (param $a i32) (param $b i32) (result i32)
    local.get $a
    local.get $b
    i32.shl)

  (func (export "shl_zero") (result i32)
    i32.const 1
    i32.const 0
    i32.shl)

  (func (export "shl_one") (result i32)
    i32.const 1
    i32.const 1
    i32.shl)

  (func (export "shl_wrap") (result i32)
    i32.const 1
    i32.const 32
    i32.shl)

  (func (export "shl_large_shift") (result i32)
    i32.const 1
    i32.const 100
    i32.shl)

  ;; Shift right (unsigned)
  (func (export "shr_u") (param $a i32) (param $b i32) (result i32)
    local.get $a
    local.get $b
    i32.shr_u)

  (func (export "shr_u_neg") (result i32)
    i32.const 0x80000000
    i32.const 1
    i32.shr_u)

  ;; Shift right (signed)
  (func (export "shr_s") (param $a i32) (param $b i32) (result i32)
    local.get $a
    local.get $b
    i32.shr_s)

  (func (export "shr_s_neg") (result i32)
    i32.const 0x80000000
    i32.const 1
    i32.shr_s)

  ;; Rotate left
  (func (export "rotl") (param $a i32) (param $b i32) (result i32)
    local.get $a
    local.get $b
    i32.rotl)

  (func (export "rotl_one") (result i32)
    i32.const 0x80000001
    i32.const 1
    i32.rotl)

  ;; Rotate right
  (func (export "rotr") (param $a i32) (param $b i32) (result i32)
    local.get $a
    local.get $b
    i32.rotr)

  (func (export "rotr_one") (result i32)
    i32.const 0x80000001
    i32.const 1
    i32.rotr)
)
