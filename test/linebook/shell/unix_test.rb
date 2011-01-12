require File.expand_path('../../../test_helper', __FILE__)
require 'linebook/shell/unix'

class UnixTest < Test::Unit::TestCase
  include Linecook::Test
  
  def cookbook_dir
    method_dir
  end
  
  def setup_recipe
    setup_package  # hack
    super.extend Linebook::Shell::Unix
  end
  
  #
  # check_status test
  #
  
  def test_check_status_silently_passes_if_error_status_is_as_expected
    script_test %Q{
      % sh $SCRIPT
    } do
      check_status_function
      
      target.puts 'true'
      check_status
      
      target.puts 'false'
      check_status 1
    end
  end
  
  def test_check_status_exits_with_error_status_if_status_is_not_as_expected
    script_test %Q{
      % sh $SCRIPT
      [0] #{method_dir}/packages/recipe:3
    } do
      check_status_function
      target.puts 'true'
      check_status 1
    end
    
    script_test %Q{
      % sh $SCRIPT
      [1] #{method_dir}/packages/recipe:3
    } do
      check_status_function
      target.puts 'false'
      check_status
    end
  end
  
  #
  # chmod test
  #
  
  def test_chomd_chmods_a_file
    path = file('example', 'content')
    
    File.chmod(0644, path)
    assert_equal "100644", sprintf("%o", File.stat(path).mode)
    
    script_path = script { 
      check_status_function
      chmod 600, path 
    }
    sh "sh #{script_path}"
    
    assert_equal "100600", sprintf("%o", File.stat(path).mode)
  end
  
  def test_chmod_does_nothing_for_no_mode
    assert_recipe %q{
    } do
      chmod nil, 'target'
    end
  end
  
  #
  # chown test
  #
  
  def test_chown_sets_up_file_chown
    assert_recipe_match %q{
      chown user:group "target"
      :...:
    } do
      chown 'user', 'group', 'target'
    end
  end
  
  def test_chown_does_nothing_for_no_user_or_group
    assert_recipe %q{
    } do
      chown nil, nil, 'target'
    end
  end
  
  #
  # recipe test
  #
  
  def test_recipe_evals_recipe_into_recipe_file
    file('recipes/child.rb') {|io| io << "target << 'content'" }
    
    recipe.recipe('child')
    recipe.close
    
    assert_equal 'content', package.content('child')
  end
end