;; Test i32 unary operations
(module
  ;; Count leading zeros
  (func (export "clz") (param $a i32) (result i32)
    local.get $a
    i32.clz)

  (func (export "clz_zero") (result i32)
    i32.const 0
    i32.clz)

  (func (export "clz_one") (result i32)
    i32.const 1
    i32.clz)

  (func (export "clz_max") (result i32)
    i32.const 0xffffffff
    i32.clz)

  (func (export "clz_high_bit") (result i32)
    i32.const 0x80000000
    i32.clz)

  ;; Count trailing zeros
  (func (export "ctz") (param $a i32) (result i32)
    local.get $a
    i32.ctz)

  (func (export "ctz_zero") (result i32)
    i32.const 0
    i32.ctz)

  (func (export "ctz_one") (result i32)
    i32.const 1
    i32.ctz)

  (func (export "ctz_max") (result i32)
    i32.const 0xffffffff
    i32.ctz)

  (func (export "ctz_high_bit") (result i32)
    i32.const 0x80000000
    i32.ctz)

  ;; Population count (count ones)
  (func (export "popcnt") (param $a i32) (result i32)
    local.get $a
    i32.popcnt)

  (func (export "popcnt_zero") (result i32)
    i32.const 0
    i32.popcnt)

  (func (export "popcnt_one") (result i32)
    i32.const 1
    i32.popcnt)

  (func (export "popcnt_max") (result i32)
    i32.const 0xffffffff
    i32.popcnt)

  (func (export "popcnt_alternating") (result i32)
    i32.const 0xaaaaaaaa
    i32.popcnt)

  ;; Equal to zero
  (func (export "eqz") (param $a i32) (result i32)
    local.get $a
    i32.eqz)

  (func (export "eqz_zero") (result i32)
    i32.const 0
    i32.eqz)

  (func (export "eqz_one") (result i32)
    i32.const 1
    i32.eqz)

  (func (export "eqz_neg") (result i32)
    i32.const -1
    i32.eqz)
)
