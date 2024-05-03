; extends

(
  (raw_string_literal) @python
  (#match? @python "api\\s*\\=\\s*(\"\\d\\.\\d\\.\\d\"|'\\d\\.\\d\\.\\d')\n")
  (#offset! @python 0 1 0 -1)
)
