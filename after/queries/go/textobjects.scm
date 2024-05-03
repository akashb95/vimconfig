; extends

; map values

(keyed_element
  (literal_element)
  (literal_element) @literal_value.inner)

(keyed_element
  (literal_element)
  (literal_element) ) @literal_value.outer

; slice values

(literal_value
  "," @_start .
  (literal_element) @literal_value.inner
  (#make-range! "literal_value.outer" @_start @literal_value.inner))

(literal_value
  . (literal_element) @literal_value.inner
  . ","? @_end
  (#make-range! "literal_value.outer" @literal_value.inner @_end))
