local priorities = {
  ["base.dap"] = 1,
  ["lang.typescript"] = 5,
  ["base.prettier"] = 10,
  -- default priority is 50
}

-- Mason can't load
-- "lang.erlang",
-- "lang.haskell",
-- "lang.ocaml",
-- "lang.r",
-- "lang.nix",
-- Causes formatting issues
-- "lang.svelte",
-- "lang.astro",
local languages = {
  "lang.angular",
  "lang.ansible",
  "lang.clangd",
  "lang.clojure",
  "lang.cmake",
  "lang.docker",
  "lang.elixir",
  "lang.elm",
  "lang.git",
  "lang.gleam",
  "lang.go",
  "lang.helm",
  "lang.java",
  "lang.json",
  "lang.kotlin",
  "lang.lean",
  "lang.markdown",
  "lang.nushell",
  "lang.omnisharp",
  "lang.php",
  "lang.prisma",
  "lang.python",
  "lang.ruby",
  "lang.rust",
  "lang.scala",
  "lang.sql",
  "lang.tailwind",
  "lang.terraform",
  "lang.tex",
  "lang.thrift",
  "lang.toml",
  "lang.typescript",
  "lang.vue",
  "lang.yaml",
}

table.sort(languages, function(a, b)
  local pa = priorities[a] or 50
  local pb = priorities[b] or 50
  if pa == pb then
    return a < b
  end
  return pa < pb
end)

---@param extra string
return vim.tbl_map(function(extra)
  return { import = extra }
end, languages)
