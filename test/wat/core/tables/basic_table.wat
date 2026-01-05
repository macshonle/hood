;; Test basic table operations
(module
  ;; Table with funcref type
  (table 4 funcref)

  ;; Functions to put in table
  (func $f0 (result i32) i32.const 0)
  (func $f1 (result i32) i32.const 1)
  (func $f2 (result i32) i32.const 2)
  (func $f3 (result i32) i32.const 42)

  ;; Element segment to initialize table
  (elem (i32.const 0) $f0 $f1 $f2 $f3)

  ;; Type for indirect calls
  (type $int_func (func (result i32)))

  ;; Call indirect through table
  (func (export "call_indirect_0") (result i32)
    i32.const 0
    call_indirect (type $int_func))

  (func (export "call_indirect_1") (result i32)
    i32.const 1
    call_indirect (type $int_func))

  (func (export "call_indirect_2") (result i32)
    i32.const 2
    call_indirect (type $int_func))

  (func (export "call_indirect_3") (result i32)
    i32.const 3
    call_indirect (type $int_func))

  ;; Call indirect with parameter
  (func (export "call_indirect_param") (param $idx i32) (result i32)
    local.get $idx
    call_indirect (type $int_func))

  ;; table.size
  (func (export "table_size") (result i32)
    table.size)
)
