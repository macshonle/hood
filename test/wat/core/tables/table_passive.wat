;; Test passive element segments and table operations
(module
  (table $t 10 funcref)

  (func $ret0 (result i32) i32.const 0)
  (func $ret1 (result i32) i32.const 1)
  (func $ret2 (result i32) i32.const 2)
  (func $ret3 (result i32) i32.const 3)
  (func $ret4 (result i32) i32.const 4)

  ;; Passive element segment
  (elem $e0 func $ret0 $ret1 $ret2)
  (elem $e1 func $ret3 $ret4)

  (type $void_to_int (func (result i32)))

  ;; table.init - copy from passive element segment to table
  (func (export "table_init") (param $dest i32) (param $src i32) (param $len i32)
    local.get $dest
    local.get $src
    local.get $len
    table.init $t $e0)

  ;; Initialize and call
  (func (export "init_and_call") (result i32)
    ;; Copy $ret0, $ret1, $ret2 to table positions 0, 1, 2
    i32.const 0  ;; dest
    i32.const 0  ;; src offset in segment
    i32.const 3  ;; length
    table.init $t $e0
    ;; Call function at index 1 (should be $ret1)
    i32.const 1
    call_indirect (type $void_to_int))

  ;; elem.drop
  (func (export "elem_drop")
    elem.drop $e0)

  ;; table.copy
  (func (export "table_copy") (param $dest i32) (param $src i32) (param $len i32)
    local.get $dest
    local.get $src
    local.get $len
    table.copy $t $t)

  ;; Init, copy, and call
  (func (export "init_copy_call") (result i32)
    ;; Init e1 at position 0
    i32.const 0  ;; dest
    i32.const 0  ;; src
    i32.const 2  ;; len
    table.init $t $e1
    ;; Copy from 0 to 5
    i32.const 5  ;; dest
    i32.const 0  ;; src
    i32.const 2  ;; len
    table.copy $t $t
    ;; Call at index 6 (should be $ret4)
    i32.const 6
    call_indirect (type $void_to_int))
)
