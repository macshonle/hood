;; Test: Get current time from realtime clock
(module
  (import "wasi_snapshot_preview1" "clock_time_get"
    (func $clock_time_get (param i32 i64 i32) (result i32)))
  (import "wasi_snapshot_preview1" "proc_exit"
    (func $proc_exit (param i32)))

  (memory (export "memory") 1)

  (func (export "_start")
    (local $result i32)
    (local $timestamp i64)

    ;; Get realtime clock
    ;; id = 0 (CLOCK_REALTIME)
    ;; precision = 1 (1 nanosecond)
    ;; timestamp pointer = 0
    (local.set $result
      (call $clock_time_get
        (i32.const 0)   ;; clock_id (realtime)
        (i64.const 1)   ;; precision
        (i32.const 0)   ;; timestamp pointer
      )
    )

    (if (i32.eq (local.get $result) (i32.const 0))
      (then
        ;; Load timestamp and verify it's > 0
        (local.set $timestamp (i64.load (i32.const 0)))
        (if (i64.gt_u (local.get $timestamp) (i64.const 0))
          (then (call $proc_exit (i32.const 0)))  ;; Success
          (else (call $proc_exit (i32.const 2)))  ;; Timestamp is 0
        )
      )
      (else
        (call $proc_exit (i32.const 1))  ;; API call failed
      )
    )
  )
)
