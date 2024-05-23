;;extends

(style_element
  (start_tag
    (attribute
      (attribute_name) @_attr
      (quoted_attribute_value
        (attribute_value) @_lang)))
  (raw_text) @injection.content
  (#eq? @_attr "lang")
  (#any-of? @_lang "scss")
  (#set! injection.language "scss"))

(style_element
  (start_tag
    (attribute
      (attribute_name) @_attr
      (quoted_attribute_value
        (attribute_value) @_lang)))
  (raw_text) @injection.content
  (#eq? @_attr "lang")
  (#any-of? @_lang "less")
  (#set! injection.language "css"))
