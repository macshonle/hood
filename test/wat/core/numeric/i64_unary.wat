;; Test i64 unary operations
(module
  ;; Count leading zeros
  (func (export "clz") (param $a i64) (result i64)
    local.get $a
    i64.clz)

  (func (export "clz_zero") (result i64)
    i64.const 0
    i64.clz)

  (func (export "clz_one") (result i64)
    i64.const 1
    i64.clz)

  (func (export "clz_max") (result i64)
    i64.const 0xffffffffffffffff
    i64.clz)

  (func (export "clz_high_bit") (result i64)
    i64.const 0x8000000000000000
    i64.clz)

  (func (export "clz_i32_max") (result i64)
    i64.const 0xffffffff
    i64.clz)

  ;; Count trailing zeros
  (func (export "ctz") (param $a i64) (result i64)
    local.get $a
    i64.ctz)

  (func (export "ctz_zero") (result i64)
    i64.const 0
    i64.ctz)

  (func (export "ctz_one") (result i64)
    i64.const 1
    i64.ctz)

  (func (export "ctz_high_bit") (result i64)
    i64.const 0x8000000000000000
    i64.ctz)

  ;; Population count
  (func (export "popcnt") (param $a i64) (result i64)
    local.get $a
    i64.popcnt)

  (func (export "popcnt_zero") (result i64)
    i64.const 0
    i64.popcnt)

  (func (export "popcnt_max") (result i64)
    i64.const 0xffffffffffffffff
    i64.popcnt)

  (func (export "popcnt_alternating") (result i64)
    i64.const 0xaaaaaaaaaaaaaaaa
    i64.popcnt)

  ;; Equal to zero
  (func (export "eqz") (param $a i64) (result i32)
    local.get $a
    i64.eqz)

  (func (export "eqz_zero") (result i32)
    i64.const 0
    i64.eqz)

  (func (export "eqz_one") (result i32)
    i64.const 1
    i64.eqz)

  (func (export "eqz_neg") (result i32)
    i64.const -1
    i64.eqz)
)
