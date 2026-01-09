;; Test: Nullable references and null checking
(module
  (type $Point (struct (field $x i32) (field $y i32)))

  ;; Test null reference
  (func (export "test_null") (result i32)
    (local $p (ref null $Point))

    ;; Create null reference
    (local.set $p (ref.null $Point))

    ;; Check if null (should return 1 for true)
    (ref.is_null (local.get $p))
  )

  ;; Test non-null reference
  (func (export "test_non_null") (result i32)
    (local $p (ref null $Point))

    ;; Create actual point
    (local.set $p (struct.new $Point (i32.const 5) (i32.const 10)))

    ;; Check if null (should return 0 for false)
    (ref.is_null (local.get $p))
  )
)
