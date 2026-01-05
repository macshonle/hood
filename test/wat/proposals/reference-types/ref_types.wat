;; Test reference types proposal (enabled by default in wabt)
(module
  (table $t 10 funcref)

  (func $f0 (result i32) i32.const 0)
  (func $f1 (result i32) i32.const 1)
  (func $f2 (result i32) i32.const 2)

  (type $void_to_int (func (result i32)))

  (elem (i32.const 0) $f0 $f1 $f2)

  ;; ref.null - create null reference
  (func (export "null_funcref") (result funcref)
    ref.null func)

  (func (export "null_externref") (result externref)
    ref.null extern)

  ;; ref.is_null - test if reference is null
  (func (export "is_null_func") (param $r funcref) (result i32)
    local.get $r
    ref.is_null)

  (func (export "is_null_extern") (param $r externref) (result i32)
    local.get $r
    ref.is_null)

  (func (export "is_null_true") (result i32)
    ref.null func
    ref.is_null)

  ;; ref.func - get reference to function
  (func (export "get_func_ref") (result funcref)
    ref.func $f0)

  (func (export "func_ref_not_null") (result i32)
    ref.func $f0
    ref.is_null)

  ;; table.get
  (func (export "table_get") (param $idx i32) (result funcref)
    local.get $idx
    table.get $t)

  ;; table.set
  (func (export "table_set") (param $idx i32)
    local.get $idx
    ref.func $f2
    table.set $t)

  ;; table.size
  (func (export "table_size") (result i32)
    table.size $t)

  ;; table.grow
  (func (export "table_grow") (param $delta i32) (result i32)
    ref.null func
    local.get $delta
    table.grow $t)

  ;; table.fill
  (func (export "table_fill") (param $start i32) (param $len i32)
    local.get $start
    ref.func $f1
    local.get $len
    table.fill $t)

  ;; Using funcref in call_indirect
  (func (export "call_from_table") (param $idx i32) (result i32)
    local.get $idx
    call_indirect (type $void_to_int))

  ;; Select with funcref
  (func (export "select_funcref") (param $cond i32) (result funcref)
    ref.func $f0
    ref.func $f1
    local.get $cond
    select (result funcref))

  ;; Externref as parameter and return
  (func (export "identity_externref") (param $r externref) (result externref)
    local.get $r)

  ;; Store externref in local
  (func (export "store_externref") (param $r externref) (result i32)
    (local $stored externref)
    local.get $r
    local.set $stored
    local.get $stored
    ref.is_null)
)
