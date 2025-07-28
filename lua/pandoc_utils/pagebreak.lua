function pagebreak(el)
    -- We're a word doc
    if (FORMAT == "docx") then
      return pandoc.RawInline('openxml', string.format([[<w:r>
    <w:br w:type="page"/>
  </w:r>
]]))
    elseif (FORMAT == "latex") then
      return pandoc.RawBlock("tex", "\\newpage{}")
    end
    return el
end
