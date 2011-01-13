def quote(arg)
  "\"#{arg}\""
end

def blank?(obj)
  obj.nil? || obj.to_s.strip.empty?
end
