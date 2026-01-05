;; Test start function that initializes memory
(module
  (memory 1)

  ;; Initialize memory with magic number
  (func $init
    i32.const 0
    i32.const 0xdeadbeef
    i32.store
    i32.const 4
    i32.const 0xcafebabe
    i32.store)

  (start $init)

  (func (export "read_magic_1") (result i32)
    i32.const 0
    i32.load)

  (func (export "read_magic_2") (result i32)
    i32.const 4
    i32.load)
)
