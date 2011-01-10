require 'linebook/shell/posix'
require 'linebook/shell/unix'

module Linebook
  module Shell
    include Posix
    include Unix
  end
end