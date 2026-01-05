;; Test module with many functions
(module
  (func $f000 (result i32) i32.const 0)
  (func $f001 (result i32) i32.const 1)
  (func $f002 (result i32) i32.const 2)
  (func $f003 (result i32) i32.const 3)
  (func $f004 (result i32) i32.const 4)
  (func $f005 (result i32) i32.const 5)
  (func $f006 (result i32) i32.const 6)
  (func $f007 (result i32) i32.const 7)
  (func $f008 (result i32) i32.const 8)
  (func $f009 (result i32) i32.const 9)
  (func $f010 (result i32) i32.const 10)
  (func $f011 (result i32) i32.const 11)
  (func $f012 (result i32) i32.const 12)
  (func $f013 (result i32) i32.const 13)
  (func $f014 (result i32) i32.const 14)
  (func $f015 (result i32) i32.const 15)
  (func $f016 (result i32) i32.const 16)
  (func $f017 (result i32) i32.const 17)
  (func $f018 (result i32) i32.const 18)
  (func $f019 (result i32) i32.const 19)
  (func $f020 (result i32) i32.const 20)
  (func $f021 (result i32) i32.const 21)
  (func $f022 (result i32) i32.const 22)
  (func $f023 (result i32) i32.const 23)
  (func $f024 (result i32) i32.const 24)
  (func $f025 (result i32) i32.const 25)
  (func $f026 (result i32) i32.const 26)
  (func $f027 (result i32) i32.const 27)
  (func $f028 (result i32) i32.const 28)
  (func $f029 (result i32) i32.const 29)
  (func $f030 (result i32) i32.const 30)
  (func $f031 (result i32) i32.const 31)
  (func $f032 (result i32) i32.const 32)
  (func $f033 (result i32) i32.const 33)
  (func $f034 (result i32) i32.const 34)
  (func $f035 (result i32) i32.const 35)
  (func $f036 (result i32) i32.const 36)
  (func $f037 (result i32) i32.const 37)
  (func $f038 (result i32) i32.const 38)
  (func $f039 (result i32) i32.const 39)
  (func $f040 (result i32) i32.const 40)
  (func $f041 (result i32) i32.const 41)
  (func $f042 (result i32) i32.const 42)
  (func $f043 (result i32) i32.const 43)
  (func $f044 (result i32) i32.const 44)
  (func $f045 (result i32) i32.const 45)
  (func $f046 (result i32) i32.const 46)
  (func $f047 (result i32) i32.const 47)
  (func $f048 (result i32) i32.const 48)
  (func $f049 (result i32) i32.const 49)
  (func $f050 (result i32) i32.const 50)

  ;; Export some
  (export "f000" (func $f000))
  (export "f025" (func $f025))
  (export "f050" (func $f050))

  ;; Function that calls many others
  (func (export "sum_all") (result i32)
    call $f000
    call $f001 i32.add
    call $f002 i32.add
    call $f003 i32.add
    call $f004 i32.add
    call $f005 i32.add
    call $f006 i32.add
    call $f007 i32.add
    call $f008 i32.add
    call $f009 i32.add
    call $f010 i32.add
    call $f011 i32.add
    call $f012 i32.add
    call $f013 i32.add
    call $f014 i32.add
    call $f015 i32.add
    call $f016 i32.add
    call $f017 i32.add
    call $f018 i32.add
    call $f019 i32.add
    call $f020 i32.add
    call $f021 i32.add
    call $f022 i32.add
    call $f023 i32.add
    call $f024 i32.add
    call $f025 i32.add
    call $f026 i32.add
    call $f027 i32.add
    call $f028 i32.add
    call $f029 i32.add
    call $f030 i32.add
    call $f031 i32.add
    call $f032 i32.add
    call $f033 i32.add
    call $f034 i32.add
    call $f035 i32.add
    call $f036 i32.add
    call $f037 i32.add
    call $f038 i32.add
    call $f039 i32.add
    call $f040 i32.add
    call $f041 i32.add
    call $f042 i32.add
    call $f043 i32.add
    call $f044 i32.add
    call $f045 i32.add
    call $f046 i32.add
    call $f047 i32.add
    call $f048 i32.add
    call $f049 i32.add
    call $f050 i32.add)
)
