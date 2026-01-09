;; Test: Create array with fixed initial elements
(module
  (type $IntArray (array i32))

  ;; Create array with specific values using array.new_fixed
  (func (export "test_new_fixed") (result i32)
    (local $arr (ref $IntArray))

    ;; Create array with 4 specific values
    (local.set $arr
      (array.new_fixed $IntArray 4
        (i32.const 1)
        (i32.const 2)
        (i32.const 3)
        (i32.const 4)))

    ;; Return sum of all elements (1+2+3+4 = 10)
    (i32.add
      (i32.add
        (array.get $IntArray (local.get $arr) (i32.const 0))
        (array.get $IntArray (local.get $arr) (i32.const 1)))
      (i32.add
        (array.get $IntArray (local.get $arr) (i32.const 2))
        (array.get $IntArray (local.get $arr) (i32.const 3))))
  )
)
