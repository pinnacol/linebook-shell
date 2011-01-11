require 'linebook/shell'
include Linebook::Shell

DEFAULT_SHELL_PATH = '/bin/bash'

def blank?(obj)
  obj.nil? || obj.to_s.strip.empty?
end