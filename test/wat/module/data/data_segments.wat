;; Test data segments
(module
  (memory 1)

  ;; Active data segment at offset 0 (string literal)
  (data (i32.const 0) "Hello, WebAssembly!")

  ;; Active data segment with hex bytes
  (data (i32.const 100) "\00\01\02\03\04\05\06\07\08\09\0a\0b\0c\0d\0e\0f")

  ;; Active data segment with escape sequences
  (data (i32.const 200) "\n\r\t\"\'\\\00")

  ;; Active data segment with Unicode (encoded as UTF-8)
  (data (i32.const 300) "Hello, 世界! 🌍")

  ;; Multiple segments at different offsets
  (data (i32.const 400) "AAAA")
  (data (i32.const 404) "BBBB")
  (data (i32.const 408) "CCCC")

  ;; Read functions
  (func (export "read_byte") (param $offset i32) (result i32)
    local.get $offset
    i32.load8_u)

  (func (export "read_i32") (param $offset i32) (result i32)
    local.get $offset
    i32.load)

  (func (export "read_hello") (result i32)
    ;; Returns 'H' = 72
    i32.const 0
    i32.load8_u)

  (func (export "read_hex_5") (result i32)
    ;; Returns 5
    i32.const 105
    i32.load8_u)

  (func (export "read_sequential") (result i32)
    ;; Read "AAAABBBB" and check
    i32.const 400
    i32.load)
)
