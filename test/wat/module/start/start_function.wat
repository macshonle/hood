;; Test start function (runs when module is instantiated)
(module
  (global $initialized (mut i32) (i32.const 0))

  ;; Start function - runs on instantiation
  (func $init
    i32.const 1
    global.set $initialized)

  (start $init)

  ;; Export to check if start ran
  (func (export "is_initialized") (result i32)
    global.get $initialized)
)
