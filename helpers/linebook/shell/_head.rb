require 'linebook/shell/unix'
include Unix

def shebang
  attributes 'linebook/shell'
  helpers attrs[:linebook][:shell][:module]
  super
end