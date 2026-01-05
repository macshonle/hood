;; Test string literal syntax in data segments
(module
  (memory 1)

  ;; Simple ASCII string
  (data (i32.const 0) "Hello, World!")

  ;; Empty string
  (data (i32.const 100) "")

  ;; Single character
  (data (i32.const 101) "A")

  ;; Escape sequences
  (data (i32.const 200) "\t")      ;; tab
  (data (i32.const 201) "\n")      ;; newline
  (data (i32.const 202) "\r")      ;; carriage return
  (data (i32.const 203) "\"")      ;; double quote
  (data (i32.const 204) "\'")      ;; single quote (optional escape)
  (data (i32.const 205) "\\")      ;; backslash
  (data (i32.const 206) "\00")     ;; null byte

  ;; Hex escapes
  (data (i32.const 300) "\00\01\02\03")
  (data (i32.const 304) "\ff\fe\fd\fc")
  (data (i32.const 308) "\de\ad\be\ef")

  ;; Mixed content
  (data (i32.const 400) "Hello\nWorld\t!")

  ;; Unicode (as UTF-8 bytes)
  (data (i32.const 500) "Hello, 世界")  ;; UTF-8 encoded
  (data (i32.const 520) "\e2\9c\93")    ;; checkmark ✓

  ;; Unicode escape sequences
  (data (i32.const 600) "\u{0041}")     ;; 'A'
  (data (i32.const 601) "\u{03B1}")     ;; Greek alpha α
  (data (i32.const 604) "\u{1F600}")    ;; Emoji 😀

  ;; All printable ASCII
  (data (i32.const 700) " !\"#$%&'()*+,-./0123456789:;<=>?@ABCDEFGHIJKLMNOPQRSTUVWXYZ[\\]^_`abcdefghijklmnopqrstuvwxyz{|}~")

  ;; Reader functions
  (func (export "read_byte") (param $addr i32) (result i32)
    local.get $addr
    i32.load8_u)

  (func (export "read_i32") (param $addr i32) (result i32)
    local.get $addr
    i32.load)

  ;; Test specific values
  (func (export "read_H") (result i32)
    i32.const 0
    i32.load8_u)  ;; 'H' = 72

  (func (export "read_tab") (result i32)
    i32.const 200
    i32.load8_u)  ;; '\t' = 9

  (func (export "read_newline") (result i32)
    i32.const 201
    i32.load8_u)  ;; '\n' = 10

  (func (export "read_deadbeef") (result i32)
    i32.const 308
    i32.load)
)
