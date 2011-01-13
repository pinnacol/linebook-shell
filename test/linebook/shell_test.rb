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
  
  def test_backup_will_copy_if_specified
    target = file('target', 'content')
    
    script_test('sh $SCRIPT') do
      backup target, :mv => false
    end
    
    assert_equal 'content', File.read(target)
    assert_equal 'content', File.read("#{target}.bak")
  end
  
  #
  # directory test
  #
  
  def test_directory_makes_the_target_directory
    target = path('target')
    assert_equal false, File.exists?(target)
    
    script_test('sh $SCRIPT') do
      directory target
    end
    
    assert_equal true, File.directory?(target)
  end
  
  def test_directory_makes_parent_dirs_as_needed
    target = path('target/dir')
    
    script_test('sh $SCRIPT') do
      directory target
    end
    
    assert_equal true, File.directory?(target)
  end
  
  def test_directory_sets_mode
    target = path('target')
    
    script_test('sh $SCRIPT') do
      directory target, :mode => 700
    end
    
    assert_equal '40700', sprintf("%o", File.stat(target).mode)
  end
  
  #
  # file test
  #
  
  def test_file_copies_source_to_target
    source = file('source', 'content')
    target = path('target')
    
    script_test('sh $SCRIPT') do
      file source, target
    end
    
    assert_equal 'content', File.read(source)
    assert_equal 'content', File.read(target)
  end
  
  def test_file_backs_up_existing_target
    source = file('source', 'new')
    target = file('target', 'old')
    
    script_test('sh $SCRIPT') do
      file source, target
    end
    
    assert_equal 'new', File.read(target)
    assert_equal 'old', File.read("#{target}.bak")
  end
  
  def test_file_can_turn_off_backup
    source = file('source', 'new')
    target = file('target', 'old')
    
    script_test('sh $SCRIPT') do
      file source, target, :backup => false
    end
    
    assert_equal false, File.exists?("#{target}.bak")
  end
  
  def test_file_makes_parent_dirs_as_needed
    source = file('source', 'content')
    target = path('target/file')
    
    script_test('sh $SCRIPT') do
      file source, target
    end
    
    assert_equal 'content', File.read(target)
  end
  
  def test_file_allows_passing_options_to_directory
    source = file('source', 'content')
    target = path('target/file')
    
    script_test('sh $SCRIPT') do
      file source, target, :directory => {:mode => 700}
    end
    
    assert_equal '40700', sprintf("%o", File.stat(path('target')).mode)
  end
  
  def test_file_sets_mode
    source = file('source', 'content')
    target = path('target')
    
    script_test('sh $SCRIPT') do
      file source, target, :mode => 600
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