;; Test whitespace handling
(module
  ;; Minimal whitespace (but still valid - spaces needed between keywords/tokens)
  (func (export "minimal") (result i32) i32.const 42)

  ;; Lots of whitespace
  (func    (export    "spaced")    (result    i32)
    i32.const     42
  )

  ;; Tab characters
	(func	(export	"tabbed")	(result	i32)
		i32.const	42)

  ;; Mixed whitespace
  (func 	(export 	"mixed") 	(result 	i32)
   	 	 i32.const   	   42)

  ;; Newlines in various places
  (func
    (export
      "newlines")
    (result
      i32)
    i32.const
      42)

  ;; No newline at end of statement
  (func (export "no_trailing") (result i32) i32.const 42)

  ;; Multiple statements on one line
  (func (export "one_line") (result i32) i32.const 1 i32.const 2 i32.add)

  ;; S-expression with various whitespace
  (func (export "sexp") (result i32)
    (i32.add
      (i32.const 1)
      (i32.const 2)))

  ;; S-expression compact
  (func (export "sexp_compact") (result i32)
    (i32.add(i32.const 1)(i32.const 2)))

  ;; Empty function body
  (func (export "empty"))
)
