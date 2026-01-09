;; Test: Basic subtyping with structs
(module
  ;; Base type: Shape with color field
  (type $Shape (struct (field $color i32)))

  ;; Derived type: Circle extends Shape with radius
  (type $Circle (sub $Shape (struct (field $color i32) (field $radius i32))))

  ;; Create circle and access as shape
  (func (export "test_subtype") (result i32)
    (local $shape (ref $Shape))
    (local $circle (ref $Circle))

    ;; Create circle with color=1 (red) and radius=10
    (local.set $circle
      (struct.new $Circle (i32.const 1) (i32.const 10)))

    ;; Upcast circle to shape (implicit)
    (local.set $shape (local.get $circle))

    ;; Access color field through shape reference
    (struct.get $Shape $color (local.get $shape))  ;; Should return 1
  )
)
