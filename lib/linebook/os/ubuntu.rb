require 'erb'

# Generated by Linecook, do not edit.
module Linebook
module Os
module Ubuntu
################################# group #################################

# 
def group(name, options={})
  cmd 'addgroup', name
end

def _group(*args, &block) # :nodoc:
  capture { group(*args, &block) }
end

############################### package ###############################

# :stopdoc:
PACKAGE_LINE = __LINE__ + 2
PACKAGE = "self." + ERB.new(<<'END_OF_TEMPLATE', nil, '<>').src
apt-get -q install <%= name %><%= blank?(version) ? nil : "=#{version}" %>
<%= check_status %>
END_OF_TEMPLATE
# :startdoc:

# 
# ==== PACKAGE ERB
#   apt-get -q install <%= name %><%= blank?(version) ? nil : "=#{version}" %>
#   <%= check_status %>
def package(name, version=nil)
  eval(PACKAGE, binding, __FILE__, PACKAGE_LINE)
  nil
end

def _package(*args, &block) # :nodoc:
  capture { package(*args, &block) }
end

################################## user ##################################

# 
def user(name, options={})
  cmd 'adduser', name
end

def _user(*args, &block) # :nodoc:
  capture { user(*args, &block) }
end
end
end
end