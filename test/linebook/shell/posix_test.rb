require File.expand_path('../../../test_helper', __FILE__)
require 'linebook/shell/posix'

class PosixTest < Test::Unit::TestCase
  include Linecook::Test
  
  def setup_recipe
    super.extend Linebook::Shell::Posix
  end
  
  def script(&block)
    recipe = setup_recipe
    recipe.result(&block)
    
    registry = package.export File.join(method_dir, 'packages')
    registry[recipe.target_name]
  end
  
  #
  # comment test
  #
  
  def test_comment_writes_a_comment_string
    assert_recipe %q{
      # string
    } do
      comment 'string'
    end
  end
  
  #
  # heredoc test
  #
  
  def test_heredoc_creates_a_heredoc_statement_using_the_block
    assert_recipe %q{
      << EOF
      line one  
        line two
      EOF
    } do
      heredoc :delimiter => 'EOF' do
        target.puts 'line one  '
        target.puts '  line two'
      end
    end
  end
  
  def test_heredoc_increments_default_delimiter
    assert_recipe %q{
      << HEREDOC_0
      HEREDOC_0
      << HEREDOC_1
      HEREDOC_1
    } do
      heredoc {}
      heredoc {}
    end
  end
  
  def test_heredoc_quotes_if_specified
    assert_recipe %q{
      << "HEREDOC_0"
      HEREDOC_0
    } do
      heredoc(:quote => true) {}
    end
  end
  
  def test_heredoc_flags_indent_if_specified
    assert_recipe %q{
      <<-HEREDOC_0
      HEREDOC_0
    } do
      heredoc(:indent => true) {}
    end
  end
  
  def test_heredoc_works_as_a_heredoc
    path = script do
      target << 'cat '
      heredoc {
        target.puts 'content'
      }
    end
    
    sh_test %Q{
      % sh '#{path}'
      content
    }
  end
  
  #
  # not_if test
  #
  
  def test_not_if_reverses_condition
    assert_recipe %q{
      if ! condition
      then
      fi
      
    } do
      not_if('condition') {}
    end
  end
  
  #
  # only_if test
  #
  
  def test_only_if_encapsulates_block_in_if_statement
    assert_recipe %q{
      if condition
      then
        content
      fi
      
    } do
      only_if('condition') { target << 'content' }
    end
  end
  
  #
  # set_options test
  #
  
  def test_set_options_writes_set_operations_to_set_options
    assert_recipe %q{
      set -o verbose
      set +o xtrace
    } do
      set_options(:verbose => true, :xtrace => false)
    end
  end
  
  def test_set_options_functions_to_set_options
    script_test %Q{
      % sh $SCRIPT
      a
      echo b
      b
      set +o verbose
      c
    } do
      target.puts 'echo a'
      set_options(:verbose => true)
      target.puts 'echo b'
      set_options(:verbose => false)
      target.puts 'echo c'
    end
  end
end