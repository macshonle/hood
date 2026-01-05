;; Test functions with many local variables
(module
  ;; Many i32 locals
  (func (export "many_i32_locals") (result i32)
    (local $l00 i32) (local $l01 i32) (local $l02 i32) (local $l03 i32)
    (local $l04 i32) (local $l05 i32) (local $l06 i32) (local $l07 i32)
    (local $l08 i32) (local $l09 i32) (local $l10 i32) (local $l11 i32)
    (local $l12 i32) (local $l13 i32) (local $l14 i32) (local $l15 i32)
    (local $l16 i32) (local $l17 i32) (local $l18 i32) (local $l19 i32)
    (local $l20 i32) (local $l21 i32) (local $l22 i32) (local $l23 i32)
    (local $l24 i32) (local $l25 i32) (local $l26 i32) (local $l27 i32)
    (local $l28 i32) (local $l29 i32) (local $l30 i32) (local $l31 i32)

    ;; Initialize each local with its index
    i32.const 0 local.set $l00
    i32.const 1 local.set $l01
    i32.const 2 local.set $l02
    i32.const 3 local.set $l03
    i32.const 4 local.set $l04
    i32.const 5 local.set $l05
    i32.const 6 local.set $l06
    i32.const 7 local.set $l07
    i32.const 8 local.set $l08
    i32.const 9 local.set $l09
    i32.const 10 local.set $l10
    i32.const 11 local.set $l11
    i32.const 12 local.set $l12
    i32.const 13 local.set $l13
    i32.const 14 local.set $l14
    i32.const 15 local.set $l15
    i32.const 16 local.set $l16
    i32.const 17 local.set $l17
    i32.const 18 local.set $l18
    i32.const 19 local.set $l19
    i32.const 20 local.set $l20
    i32.const 21 local.set $l21
    i32.const 22 local.set $l22
    i32.const 23 local.set $l23
    i32.const 24 local.set $l24
    i32.const 25 local.set $l25
    i32.const 26 local.set $l26
    i32.const 27 local.set $l27
    i32.const 28 local.set $l28
    i32.const 29 local.set $l29
    i32.const 30 local.set $l30
    i32.const 31 local.set $l31

    ;; Sum them all
    local.get $l00 local.get $l01 i32.add
    local.get $l02 i32.add local.get $l03 i32.add
    local.get $l04 i32.add local.get $l05 i32.add
    local.get $l06 i32.add local.get $l07 i32.add
    local.get $l08 i32.add local.get $l09 i32.add
    local.get $l10 i32.add local.get $l11 i32.add
    local.get $l12 i32.add local.get $l13 i32.add
    local.get $l14 i32.add local.get $l15 i32.add
    local.get $l16 i32.add local.get $l17 i32.add
    local.get $l18 i32.add local.get $l19 i32.add
    local.get $l20 i32.add local.get $l21 i32.add
    local.get $l22 i32.add local.get $l23 i32.add
    local.get $l24 i32.add local.get $l25 i32.add
    local.get $l26 i32.add local.get $l27 i32.add
    local.get $l28 i32.add local.get $l29 i32.add
    local.get $l30 i32.add local.get $l31 i32.add)

  ;; Mixed type locals
  (func (export "mixed_locals") (result i32)
    (local $i0 i32) (local $i1 i64) (local $f0 f32) (local $f1 f64)
    (local $i2 i32) (local $i3 i64) (local $f2 f32) (local $f3 f64)
    (local $i4 i32) (local $i5 i64) (local $f4 f32) (local $f5 f64)

    i32.const 10 local.set $i0
    i64.const 20 local.set $i1
    f32.const 30.0 local.set $f0
    f64.const 40.0 local.set $f1
    i32.const 50 local.set $i2
    i64.const 60 local.set $i3
    f32.const 70.0 local.set $f2
    f64.const 80.0 local.set $f3
    i32.const 90 local.set $i4
    i64.const 100 local.set $i5
    f32.const 110.0 local.set $f4
    f64.const 120.0 local.set $f5

    local.get $i0
    local.get $i1 i32.wrap_i64 i32.add
    local.get $f0 i32.trunc_f32_s i32.add
    local.get $f1 i32.trunc_f64_s i32.add
    local.get $i2 i32.add
    local.get $i3 i32.wrap_i64 i32.add
    local.get $f2 i32.trunc_f32_s i32.add
    local.get $f3 i32.trunc_f64_s i32.add
    local.get $i4 i32.add
    local.get $i5 i32.wrap_i64 i32.add
    local.get $f4 i32.trunc_f32_s i32.add
    local.get $f5 i32.trunc_f64_s i32.add)

  ;; Many params
  (func (export "many_params")
    (param $p00 i32) (param $p01 i32) (param $p02 i32) (param $p03 i32)
    (param $p04 i32) (param $p05 i32) (param $p06 i32) (param $p07 i32)
    (param $p08 i32) (param $p09 i32) (param $p10 i32) (param $p11 i32)
    (param $p12 i32) (param $p13 i32) (param $p14 i32) (param $p15 i32)
    (result i32)
    local.get $p00 local.get $p01 i32.add
    local.get $p02 i32.add local.get $p03 i32.add
    local.get $p04 i32.add local.get $p05 i32.add
    local.get $p06 i32.add local.get $p07 i32.add
    local.get $p08 i32.add local.get $p09 i32.add
    local.get $p10 i32.add local.get $p11 i32.add
    local.get $p12 i32.add local.get $p13 i32.add
    local.get $p14 i32.add local.get $p15 i32.add)
)
