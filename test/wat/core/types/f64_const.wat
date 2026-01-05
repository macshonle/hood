;; Test f64.const with various values
(module
  ;; Zero
  (func (export "zero") (result f64)
    f64.const 0.0)

  (func (export "negative_zero") (result f64)
    f64.const -0.0)

  ;; Simple values
  (func (export "one") (result f64)
    f64.const 1.0)

  (func (export "negative_one") (result f64)
    f64.const -1.0)

  (func (export "half") (result f64)
    f64.const 0.5)

  ;; Scientific notation
  (func (export "scientific_positive") (result f64)
    f64.const 1.5e100)

  (func (export "scientific_negative_exp") (result f64)
    f64.const 1.5e-100)

  (func (export "scientific_capital_e") (result f64)
    f64.const 1.5E100)

  ;; Special values
  (func (export "infinity") (result f64)
    f64.const inf)

  (func (export "negative_infinity") (result f64)
    f64.const -inf)

  (func (export "nan") (result f64)
    f64.const nan)

  (func (export "nan_canonical") (result f64)
    f64.const nan:0x8000000000000)

  (func (export "nan_arithmetic") (result f64)
    f64.const nan:0x4000000000000)

  ;; Hex float literals
  (func (export "hex_one") (result f64)
    f64.const 0x1p0)

  (func (export "hex_half") (result f64)
    f64.const 0x1p-1)

  (func (export "hex_complex") (result f64)
    f64.const 0x1.921fb54442d18p+1)  ;; approximately pi

  ;; Limits
  (func (export "max_finite") (result f64)
    f64.const 1.7976931348623157e+308)

  (func (export "min_positive") (result f64)
    f64.const 2.2250738585072014e-308)

  (func (export "min_subnormal") (result f64)
    f64.const 0x1p-1074)

  ;; High precision tests
  (func (export "pi") (result f64)
    f64.const 3.14159265358979323846)

  (func (export "e") (result f64)
    f64.const 2.71828182845904523536)

  ;; Values beyond f32 range
  (func (export "large") (result f64)
    f64.const 1e200)

  (func (export "tiny") (result f64)
    f64.const 1e-200)
)
