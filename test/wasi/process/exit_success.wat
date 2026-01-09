;; Test: Exit with success code (0)
(module
  (import "wasi_snapshot_preview1" "proc_exit"
    (func $proc_exit (param i32)))

  ;; WASI requires memory to be exported
  (memory (export "memory") 1)

  (func (export "_start")
    (call $proc_exit (i32.const 0))
  )
)
