;; Test float literal syntax
(module
  ;; Simple decimals
  (func (export "f32_0") (result f32) f32.const 0.0)
  (func (export "f32_1") (result f32) f32.const 1.0)
  (func (export "f32_pi") (result f32) f32.const 3.14159)

  ;; Negative
  (func (export "f32_neg") (result f32) f32.const -1.5)
  (func (export "f32_neg_0") (result f32) f32.const -0.0)

  ;; Decimal without leading integer (requires leading 0)
  (func (export "f32_point") (result f32) f32.const 0.5)

  ;; Integer with decimal point (requires trailing digit)
  (func (export "f32_int") (result f32) f32.const 42.0)

  ;; Scientific notation
  (func (export "f32_sci_pos") (result f32) f32.const 1e10)
  (func (export "f32_sci_neg") (result f32) f32.const 1e-10)
  (func (export "f32_sci_plus") (result f32) f32.const 1e+10)
  (func (export "f32_sci_E") (result f32) f32.const 1E10)
  (func (export "f32_sci_frac") (result f32) f32.const 1.5e10)

  ;; Special values
  (func (export "f32_inf") (result f32) f32.const inf)
  (func (export "f32_neg_inf") (result f32) f32.const -inf)
  (func (export "f32_nan") (result f32) f32.const nan)
  (func (export "f32_nan_payload") (result f32) f32.const nan:0x200000)

  ;; Hex float
  (func (export "f32_hex_1") (result f32) f32.const 0x1p0)
  (func (export "f32_hex_2") (result f32) f32.const 0x2p0)
  (func (export "f32_hex_frac") (result f32) f32.const 0x1.8p0)  ;; 1.5
  (func (export "f32_hex_exp") (result f32) f32.const 0x1p10)
  (func (export "f32_hex_neg_exp") (result f32) f32.const 0x1p-10)
  (func (export "f32_hex_complex") (result f32) f32.const 0x1.921fb6p+1)

  ;; f64 variants
  (func (export "f64_0") (result f64) f64.const 0.0)
  (func (export "f64_pi") (result f64) f64.const 3.14159265358979)
  (func (export "f64_sci") (result f64) f64.const 1.5e100)
  (func (export "f64_inf") (result f64) f64.const inf)
  (func (export "f64_nan") (result f64) f64.const nan)
  (func (export "f64_hex") (result f64) f64.const 0x1.921fb54442d18p+1)

  ;; Underscores
  (func (export "f32_underscore") (result f32) f32.const 1_000_000.5)
  (func (export "f64_underscore") (result f64) f64.const 1_000_000_000.123_456)
)
