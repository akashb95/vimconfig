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
  ","
  (literal_element) @literal_value.inner)

(literal_value
  (literal_element) @literal_value.inner
  ","?)
