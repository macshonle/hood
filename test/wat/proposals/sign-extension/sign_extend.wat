;; Test sign extension operators (enabled by default in wabt)
(module
  ;; i32.extend8_s - sign extend 8-bit to 32-bit
  (func (export "i32_extend8_s") (param $x i32) (result i32)
    local.get $x
    i32.extend8_s)

  (func (export "i32_extend8_s_pos") (result i32)
    i32.const 0x7f  ;; 127, positive 8-bit
    i32.extend8_s)

  (func (export "i32_extend8_s_neg") (result i32)
    i32.const 0x80  ;; -128 as 8-bit signed
    i32.extend8_s)

  (func (export "i32_extend8_s_ff") (result i32)
    i32.const 0xff  ;; -1 as 8-bit signed
    i32.extend8_s)

  (func (export "i32_extend8_s_truncate") (result i32)
    i32.const 0x12380  ;; Only low 8 bits (0x80) considered
    i32.extend8_s)

  ;; i32.extend16_s - sign extend 16-bit to 32-bit
  (func (export "i32_extend16_s") (param $x i32) (result i32)
    local.get $x
    i32.extend16_s)

  (func (export "i32_extend16_s_pos") (result i32)
    i32.const 0x7fff  ;; 32767, positive 16-bit
    i32.extend16_s)

  (func (export "i32_extend16_s_neg") (result i32)
    i32.const 0x8000  ;; -32768 as 16-bit signed
    i32.extend16_s)

  (func (export "i32_extend16_s_ffff") (result i32)
    i32.const 0xffff  ;; -1 as 16-bit signed
    i32.extend16_s)

  ;; i64.extend8_s
  (func (export "i64_extend8_s") (param $x i64) (result i64)
    local.get $x
    i64.extend8_s)

  (func (export "i64_extend8_s_pos") (result i64)
    i64.const 0x7f
    i64.extend8_s)

  (func (export "i64_extend8_s_neg") (result i64)
    i64.const 0x80
    i64.extend8_s)

  ;; i64.extend16_s
  (func (export "i64_extend16_s") (param $x i64) (result i64)
    local.get $x
    i64.extend16_s)

  (func (export "i64_extend16_s_pos") (result i64)
    i64.const 0x7fff
    i64.extend16_s)

  (func (export "i64_extend16_s_neg") (result i64)
    i64.const 0x8000
    i64.extend16_s)

  ;; i64.extend32_s
  (func (export "i64_extend32_s") (param $x i64) (result i64)
    local.get $x
    i64.extend32_s)

  (func (export "i64_extend32_s_pos") (result i64)
    i64.const 0x7fffffff
    i64.extend32_s)

  (func (export "i64_extend32_s_neg") (result i64)
    i64.const 0x80000000
    i64.extend32_s)

  (func (export "i64_extend32_s_ffffffff") (result i64)
    i64.const 0xffffffff
    i64.extend32_s)
)
