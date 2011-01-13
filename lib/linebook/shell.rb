require 'erb'

# Generated by Linecook, do not edit.
module Linebook
module Shell
require 'linebook/shell/unix'
include Unix

def shebang
  attributes 'linebook/shell'
  helpers attrs[:linebook][:shell][:module]
  helpers attrs[:linebook][:os][:module]
  super
end

################################ backup ################################

# Backup a file.
def backup(path, options={})
  backup_path = "#{path}.bak"
  if options[:mv]
    mv_f path, backup_path
  else
    cp_f path, backup_path
  end
  
  chmod 644, backup_path

end

def _backup(*args, &block) # :nodoc:
  capture { backup(*args, &block) }
end

############################# directory #############################

# 
def directory(target, options={})
  not_if _directory?(target) do 
    mkdir_p target
  end 
  chmod options[:mode], target
  chown options[:user], options[:group], target
end

def _directory(*args, &block) # :nodoc:
  capture { directory(*args, &block) }
end

############################### execute ###############################

# :stopdoc:
EXECUTE_LINE = __LINE__ + 2
EXECUTE = "self." + ERB.new(<<'END_OF_TEMPLATE', nil, '<>').src
<%= cmd %>

<% check_status %>

END_OF_TEMPLATE
# :startdoc:

# 
# ==== EXECUTE ERB
#   <%= cmd %>
#   
#   <% check_status %>
def execute(cmd)
  eval(EXECUTE, binding, __FILE__, EXECUTE_LINE)
  nil
end

def _execute(*args, &block) # :nodoc:
  capture { execute(*args, &block) }
end

################################## file ##################################

# Installs a file
def file(source, target, options={})
  nest_opts(options[:backup], :mv => true) do |opts|
    only_if _file?(target) do
      backup target, opts
    end
  end
  
  nest_opts(options[:directory]) do |opts|
    directory File.dirname(target), opts
  end
  
  cp source, target
  chmod options[:mode], target
  chown options[:user], options[:group], target

end

def _file(*args, &block) # :nodoc:
  capture { file(*args, &block) }
end

################################# group #################################

# 
def group(name, options={})
  raise NotImplementedError
end

def _group(*args, &block) # :nodoc:
  capture { group(*args, &block) }
end

############################### package ###############################

# 
def package(name, version=nil)
  raise NotImplementedError
end

def _package(*args, &block) # :nodoc:
  capture { package(*args, &block) }
end

################################ recipe ################################

# :stopdoc:
RECIPE_LINE = __LINE__ + 2
RECIPE = "self." + ERB.new(<<'END_OF_TEMPLATE', nil, '<>').src
"<%= env_path %>" - "<%= shell_path %>" "<%= recipe_path(name) %>" $*
<% check_status %>

END_OF_TEMPLATE
# :startdoc:

# 
# ==== RECIPE ERB
#   "<%= env_path %>" - "<%= shell_path %>" "<%= recipe_path(name) %>" $*
#   <% check_status %>
def recipe(name)
  eval(RECIPE, binding, __FILE__, RECIPE_LINE)
  nil
end

def _recipe(*args, &block) # :nodoc:
  capture { recipe(*args, &block) }
end

################################## user ##################################

# 
def user(name, options={})
  raise NotImplementedError
end

def _user(*args, &block) # :nodoc:
  capture { user(*args, &block) }
end
end
end
