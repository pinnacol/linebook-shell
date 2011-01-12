def shell_path
  @shell_path ||= '/bin/bash'
end

def blank?(obj)
  obj.nil? || obj.to_s.strip.empty?
end