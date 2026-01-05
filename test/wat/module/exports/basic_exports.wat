;; Test module exports
(module
  ;; Export function inline
  (func (export "inline_export") (result i32)
    i32.const 42)

  ;; Export function with separate export declaration
  (func $internal_func (result i32)
    i32.const 100)
  (export "separate_export" (func $internal_func))

  ;; Export with different name
  (func $my_add (param $a i32) (param $b i32) (result i32)
    local.get $a
    local.get $b
    i32.add)
  (export "renamed_export" (func $my_add))

  ;; Multiple exports for same function
  (func $multi_export_func (result i32)
    i32.const 99)
  (export "name1" (func $multi_export_func))
  (export "name2" (func $multi_export_func))

  ;; Export memory
  (memory (export "memory") 1)

  ;; Export table
  (table (export "table") 2 funcref)

  ;; Export global (immutable)
  (global (export "const_global") i32 (i32.const 42))

  ;; Export global (mutable)
  (global (export "mut_global") (mut i32) (i32.const 0))

  ;; Function by index export
  (func $func_0 (result i32) i32.const 0)
  (func $func_1 (result i32) i32.const 1)
  (export "by_index" (func 2))  ;; exports $internal_func

  ;; Export with Unicode name
  (func (export "hello_世界") (result i32)
    i32.const 12345)

  ;; Export with special characters (escaped)
  (func (export "with\tspaces") (result i32)
    i32.const 999)
)
