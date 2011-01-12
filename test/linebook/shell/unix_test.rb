require File.expand_path('../../../test_helper', __FILE__)
require 'linebook/shell/unix'

class UnixTest < Test::Unit::TestCase
  include Linecook::Test
  
  def cookbook_dir
    method_dir
  end
  
  def setup_recipe
    super.extend Linebook::Shell::Unix
  end
  
  #
  # chmod test
  #
  
  def test_chomd_chmods_a_file
    path = file('example', 'content')
    
    File.chmod(0644, path)
    assert_equal "100644", sprintf("%o", File.stat(path).mode)
    
    script_path = script { chmod 600, path }
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
  
  #
  # rm test
  #
  
  def test_rm_removes_a_file_if_present
    target = file('target')
    assert_equal true, File.exists?(target)
    
    script_test('% sh $SCRIPT') { rm target }
    assert_equal false, File.exists?(target)
  end
  
  def test_rm_removes_with_options
    a = file('target/a')
    b = file('target/b')
    target = file('target')
    
    script_test('% sh $SCRIPT') { rm target, :r => true }
    assert_equal false, File.exists?(target)
  end
  
  def test_rm_fails_if_it_cant_remove
    a = file('target/a')
    b = file('target/b')
    target = file('target')
    
    script_test %Q{
      % sh $SCRIPT
      rm: #{target}: is a directory
    } do
      rm target
    end
  end
end