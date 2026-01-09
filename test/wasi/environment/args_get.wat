;; Test: Get command-line arguments
(module
  (import "wasi_snapshot_preview1" "args_sizes_get"
    (func $args_sizes_get (param i32 i32) (result i32)))
  (import "wasi_snapshot_preview1" "args_get"
    (func $args_get (param i32 i32) (result i32)))
  (import "wasi_snapshot_preview1" "proc_exit"
    (func $proc_exit (param i32)))

  (memory (export "memory") 1)

  (func (export "_start")
    (local $result i32)
    (local $argc i32)
    (local $argv_buf_size i32)

    ;; Get argument count and buffer size
    (local.set $result
      (call $args_sizes_get
        (i32.const 0)   ;; argc pointer
        (i32.const 4)   ;; argv_buf_size pointer
      )
    )

    ;; Exit with error if args_sizes_get failed
    (if (i32.ne (local.get $result) (i32.const 0))
      (then (call $proc_exit (i32.const 1)))
    )

    ;; Load the values
    (local.set $argc (i32.load (i32.const 0)))
    (local.set $argv_buf_size (i32.load (i32.const 4)))

    ;; Get the actual arguments
    ;; argv pointer array starts at offset 100
    ;; argv buffer starts at offset 200
    (local.set $result
      (call $args_get
        (i32.const 100)   ;; argv
        (i32.const 200)   ;; argv_buf
      )
    )

    ;; Exit with the result (0 = success)
    (call $proc_exit (local.get $result))
  )
)
