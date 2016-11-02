-- helper function to check if string start with some sub-string
function string:startsWith(start)
  return string.sub(self, 1, string.len(start)) == start
end

function string:split(sep)
  local sep, fields = sep or ":", {}
  local pattern = string.format("([^%s]+)", sep)
  self:gsub(pattern, function(c) fields[#fields+1] = c end)
  return fields
end
