;; Test: Basic struct creation and field access
(module
  ;; Define a simple Point struct with two i32 fields
  (type $Point (struct (field $x i32) (field $y i32)))

  ;; Function to create a point and return x + y
  (func (export "make_point") (result i32)
    (local $p (ref $Point))

    ;; Create a new Point with x=10, y=20
    (local.set $p
      (struct.new $Point (i32.const 10) (i32.const 20)))

    ;; Return x + y
    (i32.add
      (struct.get $Point $x (local.get $p))
      (struct.get $Point $y (local.get $p)))
  )
)
