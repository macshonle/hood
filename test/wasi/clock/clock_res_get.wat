;; Test: Get clock resolution
(module
  (import "wasi_snapshot_preview1" "clock_res_get"
    (func $clock_res_get (param i32 i32) (result i32)))
  (import "wasi_snapshot_preview1" "proc_exit"
    (func $proc_exit (param i32)))

  (memory (export "memory") 1)

  (func (export "_start")
    (local $result i32)
    (local $resolution i64)

    ;; Get realtime clock resolution
    (local.set $result
      (call $clock_res_get
        (i32.const 0)   ;; clock_id (realtime)
        (i32.const 0)   ;; resolution pointer
      )
    )

    (if (i32.eq (local.get $result) (i32.const 0))
      (then
        (local.set $resolution (i64.load (i32.const 0)))
        ;; Resolution should be > 0
        (if (i64.gt_u (local.get $resolution) (i64.const 0))
          (then (call $proc_exit (i32.const 0)))
          (else (call $proc_exit (i32.const 2)))
        )
      )
      (else
        (call $proc_exit (i32.const 1))
      )
    )
  )
)
