;; Test SIMD shuffle and swizzle operations
(module
  ;; i8x16.shuffle - select 16 bytes from two 128-bit vectors
  ;; Lane indices 0-15 select from first vector, 16-31 from second

  ;; Identity shuffle (returns first vector)
  (func (export "shuffle_identity") (param $a v128) (param $b v128) (result v128)
    local.get $a
    local.get $b
    i8x16.shuffle 0 1 2 3 4 5 6 7 8 9 10 11 12 13 14 15)

  ;; Select second vector
  (func (export "shuffle_second") (param $a v128) (param $b v128) (result v128)
    local.get $a
    local.get $b
    i8x16.shuffle 16 17 18 19 20 21 22 23 24 25 26 27 28 29 30 31)

  ;; Reverse bytes
  (func (export "shuffle_reverse") (param $a v128) (param $b v128) (result v128)
    local.get $a
    local.get $b
    i8x16.shuffle 15 14 13 12 11 10 9 8 7 6 5 4 3 2 1 0)

  ;; Interleave low bytes from both vectors
  (func (export "shuffle_interleave_low") (param $a v128) (param $b v128) (result v128)
    local.get $a
    local.get $b
    i8x16.shuffle 0 16 1 17 2 18 3 19 4 20 5 21 6 22 7 23)

  ;; Interleave high bytes from both vectors
  (func (export "shuffle_interleave_high") (param $a v128) (param $b v128) (result v128)
    local.get $a
    local.get $b
    i8x16.shuffle 8 24 9 25 10 26 11 27 12 28 13 29 14 30 15 31)

  ;; Duplicate first lane
  (func (export "shuffle_dup_first") (param $a v128) (param $b v128) (result v128)
    local.get $a
    local.get $b
    i8x16.shuffle 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0)

  ;; i8x16.swizzle - rearrange bytes using index vector
  (func (export "swizzle") (param $v v128) (param $indices v128) (result v128)
    local.get $v
    local.get $indices
    i8x16.swizzle)

  ;; Swizzle with constant indices (identity)
  (func (export "swizzle_identity") (param $v v128) (result v128)
    local.get $v
    v128.const i8x16 0 1 2 3 4 5 6 7 8 9 10 11 12 13 14 15
    i8x16.swizzle)

  ;; Swizzle with reverse indices
  (func (export "swizzle_reverse") (param $v v128) (result v128)
    local.get $v
    v128.const i8x16 15 14 13 12 11 10 9 8 7 6 5 4 3 2 1 0
    i8x16.swizzle)

  ;; Swizzle with out-of-range indices (returns 0)
  (func (export "swizzle_out_of_range") (param $v v128) (result v128)
    local.get $v
    v128.const i8x16 16 17 18 19 20 21 22 23 24 25 26 27 28 29 30 31
    i8x16.swizzle)

  ;; Swizzle duplicate first byte
  (func (export "swizzle_dup_first") (param $v v128) (result v128)
    local.get $v
    v128.const i8x16 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
    i8x16.swizzle)
)
