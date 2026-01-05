;; Test multi-memory proposal (requires --enable-multi-memory)
(module
  ;; Multiple memories
  (memory $m0 1)
  (memory $m1 2)
  (memory $m2 1 4)

  ;; Data segments for each memory
  (data $m0 (memory $m0) (i32.const 0) "Memory 0")
  (data $m1 (memory $m1) (i32.const 0) "Memory 1")
  (data $m2 (memory $m2) (i32.const 0) "Memory 2")

  ;; Load from specific memories
  (func (export "load_m0") (param $addr i32) (result i32)
    local.get $addr
    i32.load $m0)

  (func (export "load_m1") (param $addr i32) (result i32)
    local.get $addr
    i32.load $m1)

  (func (export "load_m2") (param $addr i32) (result i32)
    local.get $addr
    i32.load $m2)

  ;; Store to specific memories
  (func (export "store_m0") (param $addr i32) (param $val i32)
    local.get $addr
    local.get $val
    i32.store $m0)

  (func (export "store_m1") (param $addr i32) (param $val i32)
    local.get $addr
    local.get $val
    i32.store $m1)

  (func (export "store_m2") (param $addr i32) (param $val i32)
    local.get $addr
    local.get $val
    i32.store $m2)

  ;; Size of each memory
  (func (export "size_m0") (result i32)
    memory.size $m0)

  (func (export "size_m1") (result i32)
    memory.size $m1)

  (func (export "size_m2") (result i32)
    memory.size $m2)

  ;; Grow each memory
  (func (export "grow_m0") (param $pages i32) (result i32)
    local.get $pages
    memory.grow $m0)

  (func (export "grow_m1") (param $pages i32) (result i32)
    local.get $pages
    memory.grow $m1)

  ;; Copy between memories
  (func (export "copy_m0_to_m1") (param $dest i32) (param $src i32) (param $len i32)
    local.get $dest
    local.get $src
    local.get $len
    memory.copy $m1 $m0)

  ;; Fill specific memory
  (func (export "fill_m0") (param $addr i32) (param $val i32) (param $len i32)
    local.get $addr
    local.get $val
    local.get $len
    memory.fill $m0)

  (func (export "fill_m1") (param $addr i32) (param $val i32) (param $len i32)
    local.get $addr
    local.get $val
    local.get $len
    memory.fill $m1)

  ;; Verify isolation
  (func (export "verify_isolation") (result i32)
    ;; Store different values to same address in different memories
    i32.const 0
    i32.const 0xaabbccdd
    i32.store $m0
    i32.const 0
    i32.const 0x11223344
    i32.store $m1
    ;; Read back from m0, should still be 0xaabbccdd
    i32.const 0
    i32.load $m0)
)
