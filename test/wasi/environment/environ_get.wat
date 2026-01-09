;; Test: Get environment variables
(module
  (import "wasi_snapshot_preview1" "environ_sizes_get"
    (func $environ_sizes_get (param i32 i32) (result i32)))
  (import "wasi_snapshot_preview1" "environ_get"
    (func $environ_get (param i32 i32) (result i32)))
  (import "wasi_snapshot_preview1" "proc_exit"
    (func $proc_exit (param i32)))

  (memory (export "memory") 1)

  (func (export "_start")
    (local $result i32)
    (local $environ_count i32)
    (local $environ_buf_size i32)

    ;; Get environment variable count and buffer size
    (local.set $result
      (call $environ_sizes_get
        (i32.const 0)   ;; environ_count pointer
        (i32.const 4)   ;; environ_buf_size pointer
      )
    )

    (if (i32.ne (local.get $result) (i32.const 0))
      (then (call $proc_exit (i32.const 1)))
    )

    ;; Load sizes
    (local.set $environ_count (i32.load (i32.const 0)))
    (local.set $environ_buf_size (i32.load (i32.const 4)))

    ;; Get environment variables
    ;; environ pointer array at offset 100
    ;; environ buffer at offset 1000
    (local.set $result
      (call $environ_get
        (i32.const 100)   ;; environ
        (i32.const 1000)  ;; environ_buf
      )
    )

    (call $proc_exit (local.get $result))
  )
)
