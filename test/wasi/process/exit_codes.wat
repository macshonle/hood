;; Test: Exit with various codes
;; Note: This test module can be invoked with different exports to test different exit codes
(module
  (import "wasi_snapshot_preview1" "proc_exit"
    (func $proc_exit (param i32)))

  ;; WASI requires memory to be exported
  (memory (export "memory") 1)

  (func (export "_start")
    (call $proc_exit (i32.const 0))
  )

  (func (export "exit_1")
    (call $proc_exit (i32.const 1))
  )

  (func (export "exit_42")
    (call $proc_exit (i32.const 42))
  )

  (func (export "exit_255")
    (call $proc_exit (i32.const 255))
  )
)
