;; Test bulk memory operations (enabled by default in wabt)
(module
  (memory 1)

  ;; Passive data segments
  (data $hello "Hello, World!")
  (data $numbers "\00\01\02\03\04\05\06\07\08\09")

  ;; memory.fill - fill region with byte value
  (func (export "fill") (param $dest i32) (param $val i32) (param $len i32)
    local.get $dest
    local.get $val
    local.get $len
    memory.fill)

  (func (export "fill_and_read") (result i32)
    i32.const 0
    i32.const 0x42
    i32.const 4
    memory.fill
    i32.const 0
    i32.load)  ;; Should be 0x42424242

  ;; memory.copy - copy region within memory
  (func (export "copy") (param $dest i32) (param $src i32) (param $len i32)
    local.get $dest
    local.get $src
    local.get $len
    memory.copy)

  (func (export "copy_and_read") (result i32)
    ;; Store value
    i32.const 0
    i32.const 0x12345678
    i32.store
    ;; Copy to offset 100
    i32.const 100
    i32.const 0
    i32.const 4
    memory.copy
    ;; Read from destination
    i32.const 100
    i32.load)

  ;; memory.init - copy from passive data segment
  (func (export "init") (param $dest i32) (param $src i32) (param $len i32)
    local.get $dest
    local.get $src
    local.get $len
    memory.init $hello)

  (func (export "init_hello") (result i32)
    i32.const 0
    i32.const 0
    i32.const 5
    memory.init $hello
    ;; Read 'H'
    i32.const 0
    i32.load8_u)

  (func (export "init_numbers") (result i32)
    i32.const 100
    i32.const 0
    i32.const 10
    memory.init $numbers
    i32.const 105
    i32.load8_u)  ;; Should be 5

  ;; data.drop - discard passive segment
  (func (export "drop_hello")
    data.drop $hello)

  ;; Overlapping copy (src < dest)
  (func (export "overlapping_copy_fwd") (result i32)
    ;; Fill with 0x01020304...
    i32.const 0
    i32.const 0x04030201
    i32.store
    i32.const 4
    i32.const 0x08070605
    i32.store
    ;; Copy 4 bytes from 0 to 2 (overlapping)
    i32.const 2
    i32.const 0
    i32.const 4
    memory.copy
    ;; Check result at offset 2
    i32.const 2
    i32.load)

  ;; Overlapping copy (dest < src)
  (func (export "overlapping_copy_bwd") (result i32)
    ;; Fill
    i32.const 4
    i32.const 0x44434241  ;; "ABCD"
    i32.store
    ;; Copy from 4 to 2 (dest < src)
    i32.const 2
    i32.const 4
    i32.const 4
    memory.copy
    i32.const 2
    i32.load)

  ;; Fill with zero (memset 0)
  (func (export "zero_fill") (result i32)
    ;; First store non-zero
    i32.const 0
    i32.const 0xffffffff
    i32.store
    ;; Fill with zero
    i32.const 0
    i32.const 0
    i32.const 4
    memory.fill
    i32.const 0
    i32.load)
)
