local args = vim.v.argv

for _, arg in ipairs(args) do
  if arg == "--latex" then
    require("inits/latex-init")
  elseif arg == "--inkscape" then
    require("inits/inkscape-init")
  elseif arg == "--minimal" then
    require("inits/minimal-init")
  else
    require("inits/code-init")
  end
end
