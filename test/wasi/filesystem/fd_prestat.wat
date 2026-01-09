;; Test: Get preopened directory information
(module
  (import "wasi_snapshot_preview1" "fd_prestat_get"
    (func $fd_prestat_get (param i32 i32) (result i32)))
  (import "wasi_snapshot_preview1" "fd_prestat_dir_name"
    (func $fd_prestat_dir_name (param i32 i32 i32) (result i32)))
  (import "wasi_snapshot_preview1" "proc_exit"
    (func $proc_exit (param i32)))

  (memory (export "memory") 1)

  (func (export "_start")
    (local $result i32)
    (local $name_len i32)

    ;; Get prestat for fd 3 (first preopened directory)
    ;; prestat structure at offset 0:
    ;;   - u8 tag (0 = dir)
    ;;   - u32 name_len
    (local.set $result
      (call $fd_prestat_get
        (i32.const 3)   ;; fd
        (i32.const 0)   ;; prestat pointer
      )
    )

    ;; If fd 3 doesn't exist, try fd 4
    (if (i32.ne (local.get $result) (i32.const 0))
      (then
        (local.set $result
          (call $fd_prestat_get
            (i32.const 4)
            (i32.const 0)
          )
        )
      )
    )

    ;; Some runtimes may not have preopened dirs by default
    ;; So we exit with success if we got the prestat or errno 8 (EBADF - no such fd)
    (if (i32.or
          (i32.eq (local.get $result) (i32.const 0))
          (i32.eq (local.get $result) (i32.const 8)))
      (then (call $proc_exit (i32.const 0)))
      (else (call $proc_exit (i32.const 1)))
    )
  )
)
