;; Test threads proposal - atomic operations (requires --enable-threads)
(module
  (memory 1 1 shared)

  ;; Atomic load
  (func (export "i32_atomic_load") (param $addr i32) (result i32)
    local.get $addr
    i32.atomic.load)

  (func (export "i64_atomic_load") (param $addr i32) (result i64)
    local.get $addr
    i64.atomic.load)

  (func (export "i32_atomic_load8_u") (param $addr i32) (result i32)
    local.get $addr
    i32.atomic.load8_u)

  (func (export "i32_atomic_load16_u") (param $addr i32) (result i32)
    local.get $addr
    i32.atomic.load16_u)

  ;; Atomic store
  (func (export "i32_atomic_store") (param $addr i32) (param $val i32)
    local.get $addr
    local.get $val
    i32.atomic.store)

  (func (export "i64_atomic_store") (param $addr i32) (param $val i64)
    local.get $addr
    local.get $val
    i64.atomic.store)

  (func (export "i32_atomic_store8") (param $addr i32) (param $val i32)
    local.get $addr
    local.get $val
    i32.atomic.store8)

  (func (export "i32_atomic_store16") (param $addr i32) (param $val i32)
    local.get $addr
    local.get $val
    i32.atomic.store16)

  ;; Atomic RMW add
  (func (export "i32_atomic_rmw_add") (param $addr i32) (param $val i32) (result i32)
    local.get $addr
    local.get $val
    i32.atomic.rmw.add)

  (func (export "i64_atomic_rmw_add") (param $addr i32) (param $val i64) (result i64)
    local.get $addr
    local.get $val
    i64.atomic.rmw.add)

  ;; Atomic RMW sub
  (func (export "i32_atomic_rmw_sub") (param $addr i32) (param $val i32) (result i32)
    local.get $addr
    local.get $val
    i32.atomic.rmw.sub)

  ;; Atomic RMW and
  (func (export "i32_atomic_rmw_and") (param $addr i32) (param $val i32) (result i32)
    local.get $addr
    local.get $val
    i32.atomic.rmw.and)

  ;; Atomic RMW or
  (func (export "i32_atomic_rmw_or") (param $addr i32) (param $val i32) (result i32)
    local.get $addr
    local.get $val
    i32.atomic.rmw.or)

  ;; Atomic RMW xor
  (func (export "i32_atomic_rmw_xor") (param $addr i32) (param $val i32) (result i32)
    local.get $addr
    local.get $val
    i32.atomic.rmw.xor)

  ;; Atomic RMW exchange
  (func (export "i32_atomic_rmw_xchg") (param $addr i32) (param $val i32) (result i32)
    local.get $addr
    local.get $val
    i32.atomic.rmw.xchg)

  ;; Atomic compare-exchange
  (func (export "i32_atomic_rmw_cmpxchg") (param $addr i32) (param $expected i32) (param $replacement i32) (result i32)
    local.get $addr
    local.get $expected
    local.get $replacement
    i32.atomic.rmw.cmpxchg)

  (func (export "i64_atomic_rmw_cmpxchg") (param $addr i32) (param $expected i64) (param $replacement i64) (result i64)
    local.get $addr
    local.get $expected
    local.get $replacement
    i64.atomic.rmw.cmpxchg)

  ;; memory.atomic.wait32 - wait on memory location
  (func (export "memory_atomic_wait32") (param $addr i32) (param $expected i32) (param $timeout i64) (result i32)
    local.get $addr
    local.get $expected
    local.get $timeout
    memory.atomic.wait32)

  ;; memory.atomic.notify - wake waiters
  (func (export "memory_atomic_notify") (param $addr i32) (param $count i32) (result i32)
    local.get $addr
    local.get $count
    memory.atomic.notify)

  ;; atomic.fence
  (func (export "atomic_fence")
    atomic.fence)
)
