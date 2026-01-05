;; Test f32.const with various values
(module
  ;; Zero
  (func (export "zero") (result f32)
    f32.const 0.0)

  (func (export "negative_zero") (result f32)
    f32.const -0.0)

  ;; Simple values
  (func (export "one") (result f32)
    f32.const 1.0)

  (func (export "negative_one") (result f32)
    f32.const -1.0)

  (func (export "half") (result f32)
    f32.const 0.5)

  ;; Scientific notation
  (func (export "scientific_positive") (result f32)
    f32.const 1.5e10)

  (func (export "scientific_negative_exp") (result f32)
    f32.const 1.5e-10)

  (func (export "scientific_capital_e") (result f32)
    f32.const 1.5E10)

  ;; Special values
  (func (export "infinity") (result f32)
    f32.const inf)

  (func (export "negative_infinity") (result f32)
    f32.const -inf)

  (func (export "nan") (result f32)
    f32.const nan)

  (func (export "nan_canonical") (result f32)
    f32.const nan:0x400000)

  (func (export "nan_arithmetic") (result f32)
    f32.const nan:0x200000)

  ;; Hex float literals
  (func (export "hex_one") (result f32)
    f32.const 0x1p0)

  (func (export "hex_half") (result f32)
    f32.const 0x1p-1)

  (func (export "hex_complex") (result f32)
    f32.const 0x1.921fb6p+1)  ;; approximately pi

  ;; Limits
  (func (export "max_finite") (result f32)
    f32.const 3.4028235e+38)

  (func (export "min_positive") (result f32)
    f32.const 1.175494e-38)

  (func (export "min_subnormal") (result f32)
    f32.const 0x1p-149)

  ;; Precision tests
  (func (export "pi_approx") (result f32)
    f32.const 3.14159265358979323846)

  (func (export "e_approx") (result f32)
    f32.const 2.71828182845904523536)
)
