;; Test passive data segments (bulk memory proposal - enabled by default)
(module
  (memory 1)

  ;; Passive data segment (not automatically copied to memory)
  (data $data0 "Hello")
  (data $data1 "\00\01\02\03\04\05\06\07")

  ;; memory.init - copy from passive segment to memory
  (func (export "init_data0")
    i32.const 0    ;; destination offset in memory
    i32.const 0    ;; source offset in data segment
    i32.const 5    ;; length
    memory.init $data0)

  ;; Read after init
  (func (export "init_and_read") (result i32)
    i32.const 100  ;; destination
    i32.const 0    ;; source offset
    i32.const 5    ;; length
    memory.init $data0
    i32.const 100
    i32.load8_u)  ;; Should be 'H' = 72

  ;; data.drop - discard passive segment
  (func (export "drop_data0")
    data.drop $data0)

  ;; Init numeric data
  (func (export "init_data1_and_read") (result i32)
    i32.const 200  ;; destination
    i32.const 0    ;; source
    i32.const 8    ;; length
    memory.init $data1
    i32.const 200
    i32.load)

  ;; memory.copy - copy within memory
  (func (export "copy_memory") (result i32)
    ;; First init some data
    i32.const 0
    i32.const 0x12345678
    i32.store
    ;; Copy to another location
    i32.const 100  ;; destination
    i32.const 0    ;; source
    i32.const 4    ;; length
    memory.copy
    ;; Read from destination
    i32.const 100
    i32.load)

  ;; memory.fill - fill memory with value
  (func (export "fill_memory") (result i32)
    i32.const 0    ;; destination
    i32.const 0x42 ;; value (byte)
    i32.const 4    ;; length
    memory.fill
    i32.const 0
    i32.load)  ;; Should be 0x42424242
)
