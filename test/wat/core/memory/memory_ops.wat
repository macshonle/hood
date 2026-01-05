;; Test memory operations
(module
  (memory 1 4)  ;; 1 initial page, 4 max pages

  ;; memory.size
  (func (export "size") (result i32)
    memory.size)

  ;; memory.grow
  (func (export "grow") (param $pages i32) (result i32)
    local.get $pages
    memory.grow)

  ;; Test grow and size together
  (func (export "grow_and_size") (result i32)
    i32.const 1
    memory.grow
    drop
    memory.size)

  ;; Test grow failure (exceeds max)
  (func (export "grow_exceed_max") (result i32)
    i32.const 10  ;; More than max (4 - 1 = 3 more pages allowed initially)
    memory.grow)

  ;; Fill memory with value
  (func (export "fill_and_read") (result i32)
    ;; Store values
    i32.const 0
    i32.const 0x42
    i32.store8
    i32.const 1
    i32.const 0x43
    i32.store8
    i32.const 2
    i32.const 0x44
    i32.store8
    i32.const 3
    i32.const 0x45
    i32.store8
    ;; Read back as i32
    i32.const 0
    i32.load)

  ;; Test page boundary
  (func (export "page_boundary") (result i32)
    ;; Write at end of first page
    i32.const 65532  ;; 65536 - 4
    i32.const 0xdeadbeef
    i32.store
    i32.const 65532
    i32.load)

  ;; Grow and access new memory
  (func (export "grow_and_access") (result i32)
    (local $old_size i32)
    ;; Grow by 1 page
    i32.const 1
    memory.grow
    local.set $old_size
    ;; Store in new page
    local.get $old_size
    i32.const 16
    i32.shl  ;; multiply by 65536
    i32.const 42
    i32.store
    ;; Read back
    local.get $old_size
    i32.const 16
    i32.shl
    i32.load)
)
