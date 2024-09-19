local luasnip = require("luasnip")
local parse = require("luasnip.util.parser").parse_snippet

return {
  parse(
    { trig = "tc", name = "tbl", desc = "table driven test tmpl" },
    [[testcases := []struct{
  name string
  skip bool
}{}

for _, tc := range testcases {
  s.Run(tc.name, func() {
    if tc.skip {
      s.T().Skip()
    }



  })
}]]
  )
}
