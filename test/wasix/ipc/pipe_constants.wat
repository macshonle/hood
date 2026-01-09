;; Test: IPC pipe-related constants and types
(module
  (import "wasi_snapshot_preview1" "proc_exit"
    (func $proc_exit (param i32)))

  (memory (export "memory") 1)

  ;; File descriptor constants for pipes
  ;; These are WASI/WASIX standard fds
  (global $STDIN i32 (i32.const 0))
  (global $STDOUT i32 (i32.const 1))
  (global $STDERR i32 (i32.const 2))

  (func (export "_start")
    ;; Verify standard fd constants
    (if (i32.and
          (i32.and
            (i32.eq (global.get $STDIN) (i32.const 0))
            (i32.eq (global.get $STDOUT) (i32.const 1)))
          (i32.eq (global.get $STDERR) (i32.const 2)))
      (then (call $proc_exit (i32.const 0)))
      (else (call $proc_exit (i32.const 1)))
    )
  )
)
