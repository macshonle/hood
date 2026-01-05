;; Test i64 bitwise operations
(module
  ;; AND
  (func (export "and") (param $a i64) (param $b i64) (result i64)
    local.get $a
    local.get $b
    i64.and)

  (func (export "and_zero") (result i64)
    i64.const 0xffffffffffffffff
    i64.const 0
    i64.and)

  (func (export "and_mask") (result i64)
    i64.const 0xdeadbeefcafebabe
    i64.const 0xff00ff00ff00ff00
    i64.and)

  ;; OR
  (func (export "or") (param $a i64) (param $b i64) (result i64)
    local.get $a
    local.get $b
    i64.or)

  (func (export "or_all") (result i64)
    i64.const 0xf0f0f0f0f0f0f0f0
    i64.const 0x0f0f0f0f0f0f0f0f
    i64.or)

  ;; XOR
  (func (export "xor") (param $a i64) (param $b i64) (result i64)
    local.get $a
    local.get $b
    i64.xor)

  (func (export "xor_self") (result i64)
    i64.const 0x123456789abcdef0
    i64.const 0x123456789abcdef0
    i64.xor)

  ;; Shift left
  (func (export "shl") (param $a i64) (param $b i64) (result i64)
    local.get $a
    local.get $b
    i64.shl)

  (func (export "shl_one") (result i64)
    i64.const 1
    i64.const 1
    i64.shl)

  (func (export "shl_32") (result i64)
    i64.const 1
    i64.const 32
    i64.shl)

  (func (export "shl_wrap") (result i64)
    i64.const 1
    i64.const 64
    i64.shl)

  ;; Shift right (unsigned)
  (func (export "shr_u") (param $a i64) (param $b i64) (result i64)
    local.get $a
    local.get $b
    i64.shr_u)

  (func (export "shr_u_neg") (result i64)
    i64.const 0x8000000000000000
    i64.const 1
    i64.shr_u)

  ;; Shift right (signed)
  (func (export "shr_s") (param $a i64) (param $b i64) (result i64)
    local.get $a
    local.get $b
    i64.shr_s)

  (func (export "shr_s_neg") (result i64)
    i64.const 0x8000000000000000
    i64.const 1
    i64.shr_s)

  ;; Rotate left
  (func (export "rotl") (param $a i64) (param $b i64) (result i64)
    local.get $a
    local.get $b
    i64.rotl)

  (func (export "rotl_one") (result i64)
    i64.const 0x8000000000000001
    i64.const 1
    i64.rotl)

  ;; Rotate right
  (func (export "rotr") (param $a i64) (param $b i64) (result i64)
    local.get $a
    local.get $b
    i64.rotr)

  (func (export "rotr_one") (result i64)
    i64.const 0x8000000000000001
    i64.const 1
    i64.rotr)
)
