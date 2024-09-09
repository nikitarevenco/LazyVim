---@class lazylsp.util.json
local M = {}

---@param value any
---@param indent string
local function encode(value, indent)
  local t = type(value)

  if t == "string" then
    return string.format("%q", value)
  elseif t == "number" or t == "boolean" then
    return tostring(value)
  elseif t == "table" then
    local is_list = LazyLsp.is_list(value)
    local parts = {}
    local next_indent = indent .. "  "

    if is_list then
      ---@diagnostic disable-next-line: no-unknown
      for _, v in ipairs(value) do
        local e = encode(v, next_indent)
        if e then
          table.insert(parts, next_indent .. e)
        end
      end
      return "[\n" .. table.concat(parts, ",\n") .. "\n" .. indent .. "]"
    else
      local keys = vim.tbl_keys(value)
      table.sort(keys)
      ---@diagnostic disable-next-line: no-unknown
      for _, k in ipairs(keys) do
        local e = encode(value[k], next_indent)
        if e then
          table.insert(parts, next_indent .. string.format("%q", k) .. ": " .. e)
        end
      end
      return "{\n" .. table.concat(parts, ",\n") .. "\n" .. indent .. "}"
    end
  end
end

function M.encode(value)
  return encode(value, "")
end

function M.save()
  LazyLsp.config.json.data.version = LazyLsp.config.json.version
  local f = io.open(LazyLsp.config.json.path, "w")
  if f then
    f:write(LazyLsp.json.encode(LazyLsp.config.json.data))
    f:close()
  end
end

function M.migrate()
  LazyLsp.info("Migrating `lazylsp.json` to version `" .. LazyLsp.config.json.version .. "`")
  local json = LazyLsp.config.json

  -- v0
  if not json.data.version then
    if json.data.hashes then
      ---@diagnostic disable-next-line: no-unknown
      json.data.hashes = nil
    end
    json.data.extras = vim.tbl_map(function(extra)
      return "lazylsp.plugins.extras." .. extra
    end, json.data.extras or {})
  elseif json.data.version == 1 then
    json.data.extras = vim.tbl_map(function(extra)
      -- replace double extras module name
      return extra:gsub("^lazylsp%.plugins%.extras%.lazylsp%.plugins%.extras%.", "lazylsp.plugins.extras.")
    end, json.data.extras or {})
  elseif json.data.version == 2 then
    json.data.extras = vim.tbl_map(function(extra)
      return extra == "lazylsp.plugins.extras.editor.symbols-outline" and "lazylsp.plugins.extras.editor.outline"
        or extra
    end, json.data.extras or {})
  elseif json.data.version == 3 then
    json.data.extras = vim.tbl_filter(function(extra)
      return not (
        extra == "lazylsp.plugins.extras.coding.mini-ai"
        or extra == "lazylsp.plugins.extras.ui.treesitter-rewrite"
      )
    end, json.data.extras or {})
  elseif json.data.version == 4 then
    json.data.extras = vim.tbl_filter(function(extra)
      return not (extra == "lazylsp.plugins.extras.lazyrc")
    end, json.data.extras or {})
  elseif json.data.version == 5 then
    json.data.extras = vim.tbl_filter(function(extra)
      return not (extra == "lazylsp.plugins.extras.editor.trouble-v3")
    end, json.data.extras or {})
  end

  M.save()
end

return M
