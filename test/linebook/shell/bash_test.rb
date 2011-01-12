require File.expand_path('../../../test_helper', __FILE__)
require 'linebook/shell/bash'

class BashTest < Test::Unit::TestCase
  include Linecook::Test
  
  def setup_recipe
    recipe = super
    recipe.extend Linebook::Shell
    recipe.extend Linebook::Shell::Bash
  end
  
  #
  # su test
  #
  
  def test_su_wraps_block_content_in_a_recipe
    assert_recipe(%{
      su root "$LINECOOK_DIR/recipe.d/root"
      check_status 0 $? $LINENO
      
    }){ 
      su('root') do 
        comment('content')
      end
    }
    
    assert_equal "# content\n", package.content('recipe.d/root')
  end
  
  def test_nested_su
    assert_recipe %q{
      # +A
      su a "$LINECOOK_DIR/recipe.d/a"
      check_status 0 $? $LINENO
      
      # -A
    } do
      comment('+A')
      su('a') do 
        comment('+B')
        su('b') do
          comment('+C')
          su('c') do
            comment('+D')
            comment('-D')
          end
          comment('-C')
        end
        comment('-B')
      end
      comment('-A')
    end
    
    assert_output_equal %q{
      # +B
      su b "$LINECOOK_DIR/recipe.d/b"
      check_status 0 $? $LINENO
      
      # -B
    }, package.content('recipe.d/a')
    
    assert_output_equal %q{
      # +C
      su c "$LINECOOK_DIR/recipe.d/c"
      check_status 0 $? $LINENO
      
      # -C
    }, package.content('recipe.d/b')
    
    assert_output_equal %q{
      # +D
      # -D
    }, package.content('recipe.d/c')
  end
end
