;; Test memory64 proposal (requires --enable-memory64)
;; Uses 64-bit address space for memory
(module
  ;; Memory with i64 index type
  (memory i64 1)

  ;; Store and load with 64-bit addresses
  (func (export "i32_store_load") (param $addr i64) (param $val i32) (result i32)
    local.get $addr
    local.get $val
    i32.store
    local.get $addr
    i32.load)

  (func (export "i64_store_load") (param $addr i64) (param $val i64) (result i64)
    local.get $addr
    local.get $val
    i64.store
    local.get $addr
    i64.load)

  (func (export "f32_store_load") (param $addr i64) (param $val f32) (result f32)
    local.get $addr
    local.get $val
    f32.store
    local.get $addr
    f32.load)

  (func (export "f64_store_load") (param $addr i64) (param $val f64) (result f64)
    local.get $addr
    local.get $val
    f64.store
    local.get $addr
    f64.load)

  ;; Partial loads/stores
  (func (export "i32_load8_s") (param $addr i64) (result i32)
    local.get $addr
    i32.load8_s)

  (func (export "i32_load8_u") (param $addr i64) (result i32)
    local.get $addr
    i32.load8_u)

  (func (export "i32_store8") (param $addr i64) (param $val i32)
    local.get $addr
    local.get $val
    i32.store8)

  ;; memory.size returns i64
  (func (export "size") (result i64)
    memory.size)

  ;; memory.grow takes and returns i64
  (func (export "grow") (param $pages i64) (result i64)
    local.get $pages
    memory.grow)

  ;; memory.fill with i64 addresses
  (func (export "fill") (param $addr i64) (param $val i32) (param $len i64)
    local.get $addr
    local.get $val
    local.get $len
    memory.fill)

  ;; memory.copy with i64 addresses
  (func (export "copy") (param $dest i64) (param $src i64) (param $len i64)
    local.get $dest
    local.get $src
    local.get $len
    memory.copy)
)
