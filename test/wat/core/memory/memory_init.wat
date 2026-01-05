;; Test memory with data segments
(module
  (memory 1)

  ;; Active data segment at offset 0
  (data (i32.const 0) "Hello, World!")

  ;; Active data segment at offset 100
  (data (i32.const 100) "\00\01\02\03\04\05\06\07\08\09")

  ;; Hex encoded data
  (data (i32.const 200) "\de\ad\be\ef")

  ;; Read first byte of string
  (func (export "read_char_0") (result i32)
    i32.const 0
    i32.load8_u)  ;; 'H' = 72

  ;; Read second byte
  (func (export "read_char_1") (result i32)
    i32.const 1
    i32.load8_u)  ;; 'e' = 101

  ;; Read from second data segment
  (func (export "read_data_100") (result i32)
    i32.const 100
    i32.load8_u)  ;; 0

  (func (export "read_data_105") (result i32)
    i32.const 105
    i32.load8_u)  ;; 5

  ;; Read hex data as i32
  (func (export "read_hex_data") (result i32)
    i32.const 200
    i32.load)

  ;; Overwrite and read
  (func (export "overwrite_and_read") (result i32)
    i32.const 0
    i32.const 0x58585858  ;; "XXXX"
    i32.store
    i32.const 0
    i32.load)
)
