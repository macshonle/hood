;; Test: Write "Hello, WASI!\n" to stdout
(module
  ;; Import WASI functions
  (import "wasi_snapshot_preview1" "fd_write"
    (func $fd_write (param i32 i32 i32 i32) (result i32)))
  (import "wasi_snapshot_preview1" "proc_exit"
    (func $proc_exit (param i32)))

  ;; Memory for I/O vectors and string data
  (memory (export "memory") 1)

  ;; Store the string "Hello, WASI!\n" at memory offset 8
  (data (i32.const 8) "Hello, WASI!\n")

  (func (export "_start")
    (local $iovs_ptr i32)
    (local $nwritten_ptr i32)
    (local $result i32)

    ;; Set up iovec structure at memory offset 0
    ;; iovec.buf = 8 (pointer to string)
    ;; iovec.buf_len = 13 (length of string)
    (i32.store (i32.const 0) (i32.const 8))
    (i32.store (i32.const 4) (i32.const 13))

    ;; Call fd_write
    ;; fd=1 (stdout), iovs=0, iovs_len=1, nwritten=28
    (local.set $result
      (call $fd_write
        (i32.const 1)   ;; fd (stdout)
        (i32.const 0)   ;; iovs pointer
        (i32.const 1)   ;; iovs length (1 vector)
        (i32.const 28)  ;; nwritten pointer
      )
    )

    ;; Check result and exit
    (if (i32.eq (local.get $result) (i32.const 0))
      (then
        (call $proc_exit (i32.const 0))  ;; Success
      )
      (else
        (call $proc_exit (i32.const 1))  ;; Failure
      )
    )
  )
)
