;; Test: Write "Error message\n" to stderr
(module
  (import "wasi_snapshot_preview1" "fd_write"
    (func $fd_write (param i32 i32 i32 i32) (result i32)))
  (import "wasi_snapshot_preview1" "proc_exit"
    (func $proc_exit (param i32)))

  (memory (export "memory") 1)
  (data (i32.const 8) "Error message\n")

  (func (export "_start")
    (local $result i32)

    ;; Set up iovec: buf=8, buf_len=14
    (i32.store (i32.const 0) (i32.const 8))
    (i32.store (i32.const 4) (i32.const 14))

    ;; Write to stderr (fd=2)
    (local.set $result
      (call $fd_write
        (i32.const 2)   ;; fd (stderr)
        (i32.const 0)   ;; iovs
        (i32.const 1)   ;; iovs_len
        (i32.const 28)  ;; nwritten
      )
    )

    (call $proc_exit (local.get $result))
  )
)
