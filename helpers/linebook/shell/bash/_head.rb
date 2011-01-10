require 'linebook/shell'
require 'linebook/shell/patch/linecook_recipe.rb'
include Linebook::Shell

DEFAULT_SHELL_PATH = '/bin/bash'

def blank?(obj)
  obj.nil? || obj.to_s.strip.empty?
end