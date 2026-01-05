;; Test table operations (reference types proposal - enabled by default)
(module
  (table $t 4 10 funcref)

  (func $double (param $x i32) (result i32)
    local.get $x
    i32.const 2
    i32.mul)

  (func $triple (param $x i32) (result i32)
    local.get $x
    i32.const 3
    i32.mul)

  (func $add10 (param $x i32) (result i32)
    local.get $x
    i32.const 10
    i32.add)

  ;; Initialize table
  (elem (i32.const 0) $double $triple $add10)

  (type $int_to_int (func (param i32) (result i32)))

  ;; table.get (returns funcref)
  (func (export "get_and_call") (param $idx i32) (param $val i32) (result i32)
    local.get $val
    local.get $idx
    call_indirect (type $int_to_int))

  ;; table.set (set table entry)
  (func (export "set_entry") (param $idx i32)
    local.get $idx
    ref.func $add10
    table.set $t)

  ;; table.grow
  (func (export "table_grow") (param $delta i32) (result i32)
    ref.null func
    local.get $delta
    table.grow $t)

  ;; table.size
  (func (export "table_size") (result i32)
    table.size $t)

  ;; table.fill
  (func (export "table_fill") (param $start i32) (param $len i32)
    local.get $start
    ref.func $double
    local.get $len
    table.fill $t)

  ;; Test call after fill
  (func (export "fill_and_call") (result i32)
    ;; Fill entries 0-2 with $triple
    i32.const 0
    ref.func $triple
    i32.const 3
    table.fill $t
    ;; Call entry 1 with value 5
    i32.const 5
    i32.const 1
    call_indirect (type $int_to_int))
)
