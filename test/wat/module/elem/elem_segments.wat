;; Test element segments
(module
  (table 10 funcref)

  ;; Functions for the table
  (func $f0 (result i32) i32.const 0)
  (func $f1 (result i32) i32.const 1)
  (func $f2 (result i32) i32.const 2)
  (func $f3 (result i32) i32.const 3)
  (func $f4 (result i32) i32.const 4)

  (type $void_to_int (func (result i32)))

  ;; Active element segment at offset 0
  (elem (i32.const 0) $f0 $f1 $f2)

  ;; Active element segment at offset 5
  (elem (i32.const 5) $f3 $f4)

  ;; Call through table
  (func (export "call_0") (result i32)
    i32.const 0
    call_indirect (type $void_to_int))

  (func (export "call_1") (result i32)
    i32.const 1
    call_indirect (type $void_to_int))

  (func (export "call_2") (result i32)
    i32.const 2
    call_indirect (type $void_to_int))

  (func (export "call_5") (result i32)
    i32.const 5
    call_indirect (type $void_to_int))

  (func (export "call_6") (result i32)
    i32.const 6
    call_indirect (type $void_to_int))

  (func (export "call_at") (param $idx i32) (result i32)
    local.get $idx
    call_indirect (type $void_to_int))
)
