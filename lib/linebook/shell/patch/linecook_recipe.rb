require 'linecook/recipe'

module Linecook
  class Recipe
    attr_reader :target_name
    attr_reader :target_dir_name
  
    def initialize(target, package)
      @erbout      = target
      @package     = package
      @attributes  = Attributes.new(@package.env)
      @target_name = @package.target_path(target.path)
      @target_dir_name = "#{target_name}.d"
    end
  end
end