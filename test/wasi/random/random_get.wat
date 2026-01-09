;; Test: Generate random bytes
(module
  (import "wasi_snapshot_preview1" "random_get"
    (func $random_get (param i32 i32) (result i32)))
  (import "wasi_snapshot_preview1" "proc_exit"
    (func $proc_exit (param i32)))

  (memory (export "memory") 1)

  (func (export "_start")
    (local $result i32)
    (local $random1 i64)
    (local $random2 i64)

    ;; Get 16 random bytes at offset 0
    (local.set $result
      (call $random_get
        (i32.const 0)   ;; buffer
        (i32.const 16)  ;; length
      )
    )

    (if (i32.eq (local.get $result) (i32.const 0))
      (then
        ;; Load two i64 values to verify we got random data
        (local.set $random1 (i64.load (i32.const 0)))
        (local.set $random2 (i64.load (i32.const 8)))

        ;; Very simple check: at least one of them should be non-zero
        ;; (technically could both be zero but extremely unlikely)
        (if (i64.or (local.get $random1) (local.get $random2))
          (then (call $proc_exit (i32.const 0)))  ;; Success
          (else (call $proc_exit (i32.const 2)))  ;; Both zero (unlikely)
        )
      )
      (else
        (call $proc_exit (i32.const 1))  ;; API call failed
      )
    )
  )
)
