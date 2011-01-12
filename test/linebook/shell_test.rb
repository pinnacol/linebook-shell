require File.expand_path('../../test_helper', __FILE__)
require 'linebook/shell'
require 'linecook/test'

class ShellTest < Test::Unit::TestCase
  include Linecook::Test
  
  def setup_recipe
    super.extend Linebook::Shell
  end
  
  #
  # shebang test
  #
  
  def test_shebang_adds_shebang_line_for_bash
    assert_recipe_match %q{
      #! /bin/bash
      :...:
    } do
      shebang
    end
  end
end