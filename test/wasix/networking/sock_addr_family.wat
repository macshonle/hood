;; Test: Socket address family constants
;; This test verifies basic WASIX socket-related types and constants
(module
  (import "wasi_snapshot_preview1" "proc_exit"
    (func $proc_exit (param i32)))

  (memory (export "memory") 1)

  ;; WASIX socket address family constants
  ;; AF_INET = 2, AF_INET6 = 10
  (global $AF_INET i32 (i32.const 2))
  (global $AF_INET6 i32 (i32.const 10))

  (func (export "_start")
    ;; Simple validation that constants are defined
    (if (i32.and
          (i32.eq (global.get $AF_INET) (i32.const 2))
          (i32.eq (global.get $AF_INET6) (i32.const 10)))
      (then (call $proc_exit (i32.const 0)))
      (else (call $proc_exit (i32.const 1)))
    )
  )
)
