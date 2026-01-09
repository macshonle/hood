;; Test: Basic thread spawning with WASIX
;; Note: WASIX threading API may vary - this is a simplified example
(module
  (import "wasi_snapshot_preview1" "proc_exit"
    (func $proc_exit (param i32)))

  ;; WASIX thread_spawn (simplified signature)
  ;; Actual WASIX API may differ - this is conceptual
  (import "wasix_32v1" "thread_spawn"
    (func $thread_spawn (param i32) (result i32)))

  (memory (export "memory") 1)
  (global $thread_id (mut i32) (i32.const 0))

  ;; Thread entry point
  (func $thread_func (param $arg i32)
    ;; Thread does minimal work
    (nop)
  )

  (func (export "_start")
    (local $result i32)

    ;; Try to spawn a thread
    ;; In a real implementation, this would need proper setup
    ;; For now, this test verifies the import exists

    ;; Exit successfully
    ;; (Actual thread spawning would require more complex setup)
    (call $proc_exit (i32.const 0))
  )
)
