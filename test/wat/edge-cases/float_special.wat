;; Test special float values and behaviors
(module
  ;; Positive and negative zero
  (func (export "pos_zero") (result f32) f32.const 0.0)
  (func (export "neg_zero") (result f32) f32.const -0.0)

  ;; Zero equality (positive and negative zero are equal)
  (func (export "zero_eq") (result i32)
    f32.const 0.0
    f32.const -0.0
    f32.eq)

  ;; Zero inequality in bits
  (func (export "zero_bits_diff") (result i32)
    f32.const 0.0
    i32.reinterpret_f32
    f32.const -0.0
    i32.reinterpret_f32
    i32.ne)

  ;; Infinity
  (func (export "inf_eq_inf") (result i32)
    f32.const inf
    f32.const inf
    f32.eq)

  (func (export "neg_inf_lt_inf") (result i32)
    f32.const -inf
    f32.const inf
    f32.lt)

  ;; Infinity arithmetic
  (func (export "inf_plus_1") (result f32)
    f32.const inf
    f32.const 1.0
    f32.add)

  (func (export "inf_minus_inf") (result f32)
    f32.const inf
    f32.const inf
    f32.sub)  ;; NaN

  (func (export "inf_times_0") (result f32)
    f32.const inf
    f32.const 0.0
    f32.mul)  ;; NaN

  ;; NaN behavior
  (func (export "nan_eq_nan") (result i32)
    f32.const nan
    f32.const nan
    f32.eq)  ;; 0 (false)

  (func (export "nan_ne_nan") (result i32)
    f32.const nan
    f32.const nan
    f32.ne)  ;; 1 (true)

  (func (export "nan_lt_nan") (result i32)
    f32.const nan
    f32.const nan
    f32.lt)  ;; 0

  (func (export "nan_gt_nan") (result i32)
    f32.const nan
    f32.const nan
    f32.gt)  ;; 0

  ;; NaN propagation
  (func (export "nan_plus_1") (result f32)
    f32.const nan
    f32.const 1.0
    f32.add)

  (func (export "nan_times_2") (result f32)
    f32.const nan
    f32.const 2.0
    f32.mul)

  ;; Subnormal numbers
  (func (export "subnormal") (result f32)
    f32.const 0x0.000002p-126)  ;; Smallest positive subnormal

  (func (export "subnormal_times_2") (result f32)
    f32.const 0x0.000002p-126
    f32.const 2.0
    f32.mul)

  ;; Underflow to zero
  (func (export "underflow") (result f32)
    f32.const 0x1p-149  ;; Smallest subnormal
    f32.const 0.5
    f32.mul)  ;; May underflow to 0

  ;; Overflow to infinity
  (func (export "overflow") (result f32)
    f32.const 0x1.fffffep+127
    f32.const 2.0
    f32.mul)

  ;; copysign with special values
  (func (export "copysign_nan") (result f32)
    f32.const nan
    f32.const -1.0
    f32.copysign)

  (func (export "copysign_inf") (result f32)
    f32.const inf
    f32.const -1.0
    f32.copysign)

  ;; min/max with special values
  (func (export "min_nan") (result f32)
    f32.const 1.0
    f32.const nan
    f32.min)

  (func (export "max_nan") (result f32)
    f32.const 1.0
    f32.const nan
    f32.max)

  ;; f64 versions
  (func (export "f64_inf_minus_inf") (result f64)
    f64.const inf
    f64.const inf
    f64.sub)

  (func (export "f64_nan_eq_nan") (result i32)
    f64.const nan
    f64.const nan
    f64.eq)
)
