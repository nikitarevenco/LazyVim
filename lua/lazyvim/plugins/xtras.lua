-- Some extras need to be loaded before others
local prios = {
  ["lazyvim.plugins.extras.test.core"] = 1,
  ["lazyvim.plugins.extras.dap.core"] = 1,
  ["lazyvim.plugins.extras.ui.edgy"] = 2,
  ["lang.typescript"] = 5,
  ["lazyvim.plugins.extras.formatting.prettier"] = 10,
  -- default priority is 50
  ["lazyvim.plugins.extras.editor.aerial"] = 100,
  ["lazyvim.plugins.extras.editor.outline"] = 100,
}

-- "lang.erlang",
-- "lang.haskell",
-- "lang.ocaml",
-- "lang.r",
-- "lang.nix",
local extras = {
  -- "lang.angular",
  -- "lang.ansible",
  -- "lang.astro",
  -- "lang.clangd",
  -- "lang.clojure",
  -- "lang.cmake",
  -- "lang.docker",
  -- "lang.elixir",
  -- "lang.elm",
  -- "lang.git",
  -- "lang.gleam",
  -- "lang.go",
  -- "lang.helm",
  -- "lang.java",
  -- "lang.json",
  -- "lang.kotlin",
  -- "lang.lean",
  -- "lang.markdown",
  -- "lang.nushell",
  -- "lang.omnisharp",
  -- "lang.php",
  -- "lang.prisma",
  -- "lang.python",
  -- "lang.ruby",
  -- "lang.rust",
  -- "lang.scala",
  -- "lang.sql",
  -- "lang.svelte",
  -- "lang.tailwind",
  -- "lang.terraform",
  -- "lang.tex",
  -- "lang.thrift",
  -- "lang.toml",
  -- "lang.typescript",
  -- "lang.vue",
  -- "lang.yaml",
}

local version = vim.version()
local v = version.major .. "_" .. version.minor

local compat = { "0_9" }

LazyVim.plugin.save_core()
if vim.tbl_contains(compat, v) then
  table.insert(extras, 1, "compatibility-" .. v)
end

table.sort(extras, function(a, b)
  local pa = prios[a] or 50
  local pb = prios[b] or 50
  if pa == pb then
    return a < b
  end
  return pa < pb
end)

---@param extra string
return vim.tbl_map(function(extra)
  return { import = extra }
end, extras)
