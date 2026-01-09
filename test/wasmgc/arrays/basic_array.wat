;; Test: Basic array creation and element access
(module
  ;; Define an array type for i32 elements
  (type $IntArray (array (mut i32)))

  ;; Create array, set elements, return sum
  (func (export "test_array") (result i32)
    (local $arr (ref $IntArray))
    (local $sum i32)

    ;; Create array with 3 elements, all initialized to 0
    (local.set $arr (array.new $IntArray (i32.const 0) (i32.const 3)))

    ;; Set elements: arr[0] = 10, arr[1] = 20, arr[2] = 30
    (array.set $IntArray (local.get $arr) (i32.const 0) (i32.const 10))
    (array.set $IntArray (local.get $arr) (i32.const 1) (i32.const 20))
    (array.set $IntArray (local.get $arr) (i32.const 2) (i32.const 30))

    ;; Calculate sum
    (local.set $sum
      (i32.add
        (i32.add
          (array.get $IntArray (local.get $arr) (i32.const 0))
          (array.get $IntArray (local.get $arr) (i32.const 1)))
        (array.get $IntArray (local.get $arr) (i32.const 2))))

    ;; Return sum (should be 60)
    (local.get $sum)
  )

  ;; Test array length
  (func (export "test_array_len") (result i32)
    (local $arr (ref $IntArray))
    (local.set $arr (array.new $IntArray (i32.const 0) (i32.const 5)))
    (array.len (local.get $arr))  ;; Should return 5
  )
)
