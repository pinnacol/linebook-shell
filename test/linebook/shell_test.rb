require File.expand_path('../../test_helper', __FILE__)
require 'linebook/shell'
require 'linecook/test'

class ShellTest < Test::Unit::TestCase
  include Linecook::Test
  
  def cookbook_dir
    method_dir
  end
  
  def setup_recipe
    super.extend Linebook::Shell
  end
  
  #
  # backup test
  #
  
  def test_backup_set_backup_permissions_to_644
    target = file('target', 'content')
    File.chmod(0754, target)
    
    script_test('sh $SCRIPT') do
      backup target
    end
    
    assert_equal '100644', sprintf("%o", File.stat("#{target}.bak").mode)
  end
  
  #
  # prepare test
  #
  
  def test_prepare_removes_and_backs_up_existing_target
    target = file('target', 'content')
    
    script_test('sh $SCRIPT') do
      prepare target
    end
    
    assert_equal false, File.exists?(target)
    assert_equal 'content', File.read("#{target}.bak")
  end
  
  def test_prepare_makes_parent_dirs_as_needed
    target = path('target/file')
    
    script_test('sh $SCRIPT') do
      prepare target
    end
    
    assert_equal true, File.directory?(path('target'))
  end
  
  #
  # install test
  #
  
  def test_install_copies_source_to_target
    source = file('source', 'content')
    target = path('target')
    
    script_test('sh $SCRIPT') do
      install source, target
    end
    
    assert_equal 'content', File.read(source)
    assert_equal 'content', File.read(target)
  end
  
  def test_install_backs_up_existing_target
    source = file('source', 'new')
    target = file('target', 'old')
    
    script_test('sh $SCRIPT') do
      install source, target
    end
    
    assert_equal 'new', File.read(target)
    assert_equal 'old', File.read("#{target}.bak")
  end
  
  def test_install_makes_parent_dirs_as_needed
    source = file('source', 'content')
    target = path('target/file')
    
    script_test('sh $SCRIPT') do
      install source, target
    end
    
    assert_equal 'content', File.read(target)
  end
  
  def test_install_sets_mode
    source = file('source', 'content')
    target = path('target')
    
    script_test('sh $SCRIPT') do
      install source, target, :mode => 600
    end
    
    assert_equal '100600', sprintf("%o", File.stat(target).mode)
  end
  
  #
  # shebang test
  #
  
  def test_shebang_adds_shebang_line_for_sh
    assert_recipe_match %q{
      #! /bin/bash
      :...:
    } do
      shebang
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