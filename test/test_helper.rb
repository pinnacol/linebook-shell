require 'rubygems'
require 'bundler'
Bundler.setup

require 'test/unit'
require 'linecook/test'

module Linecook::Test
  def script(&block)
    recipe = setup_recipe
    recipe.result(&block)
    
    registry = package.export File.join(method_dir, 'packages')
    registry[recipe.target_name]
  end
end