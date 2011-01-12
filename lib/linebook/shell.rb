require 'linebook/shell/posix'
require 'linebook/shell/unix'

module Linebook
  module Shell
    include Posix
    include Unix
    
    def shebang
      attributes 'linebook/shell'
      helpers attrs[:linebook][:shell][:module]
      super
    end
  end
end