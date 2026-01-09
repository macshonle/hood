;; Test: Struct with mutable fields
(module
  ;; Define a Counter struct with mutable count field
  (type $Counter (struct (field $count (mut i32))))

  ;; Create counter, increment it, and return value
  (func (export "test_counter") (result i32)
    (local $c (ref $Counter))

    ;; Create counter with initial value 0
    (local.set $c (struct.new $Counter (i32.const 0)))

    ;; Increment counter
    (struct.set $Counter $count (local.get $c)
      (i32.add
        (struct.get $Counter $count (local.get $c))
        (i32.const 1)))

    ;; Increment again
    (struct.set $Counter $count (local.get $c)
      (i32.add
        (struct.get $Counter $count (local.get $c))
        (i32.const 1)))

    ;; Return final count (should be 2)
    (struct.get $Counter $count (local.get $c))
  )
)
