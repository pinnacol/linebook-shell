require 'erb'

# Generated by Linecook, do not edit.
module Linebook
module Shell
module Posix
########################## check_status ##########################

# :stopdoc:
CHECK_STATUS_LINE = __LINE__ + 2
CHECK_STATUS = "self." + ERB.new(<<'END_OF_TEMPLATE', nil, '<>').src
<% if @check_status %>
check_status <%= status %> $? $LINENO
<% end %>
END_OF_TEMPLATE
# :startdoc:

# Adds a check that ensures the last exit status is as indicated. Note that no
# check will be added unless check_status_function is added beforehand.
# 
# ==== CHECK_STATUS ERB
#   <% if @check_status %>
#   check_status <%= status %> $? $LINENO
#   <% end %>
def check_status(status=0)
  @check_status ||= false
  eval(CHECK_STATUS, binding, __FILE__, CHECK_STATUS_LINE)
  nil
end

def _check_status(*args, &block) # :nodoc:
  capture { check_status(*args, &block) }
end

################# check_status_function #################

# :stopdoc:
CHECK_STATUS_FUNCTION_LINE = __LINE__ + 2
CHECK_STATUS_FUNCTION = "self." + ERB.new(<<'END_OF_TEMPLATE', nil, '<>').src
function check_status { if [ $1 -ne $2 ]; then echo "[$2] $0:$3"; exit $2; fi }
END_OF_TEMPLATE
# :startdoc:

# Adds the check status function.
# ==== CHECK_STATUS_FUNCTION ERB
#   function check_status { if [ $1 -ne $2 ]; then echo "[$2] $0:$3"; exit $2; fi }
def check_status_function()
  @check_status = true
  eval(CHECK_STATUS_FUNCTION, binding, __FILE__, CHECK_STATUS_FUNCTION_LINE)
  nil
end

def _check_status_function(*args, &block) # :nodoc:
  capture { check_status_function(*args, &block) }
end

############################### comment ###############################

# :stopdoc:
COMMENT_LINE = __LINE__ + 2
COMMENT = "self." + ERB.new(<<'END_OF_TEMPLATE', nil, '<>').src
# <%= str %>
END_OF_TEMPLATE
# :startdoc:

# Writes a comment
# ==== COMMENT ERB
#   # <%= str %>
def comment(str)
  eval(COMMENT, binding, __FILE__, COMMENT_LINE)
  nil
end

def _comment(*args, &block) # :nodoc:
  capture { comment(*args, &block) }
end

############################### heredoc ###############################

# :stopdoc:
HEREDOC_LINE = __LINE__ + 2
HEREDOC = "self." + ERB.new(<<'END_OF_TEMPLATE', nil, '<>').src
<<<%= options[:indent] ? '-' : ' '%><%= options[:quote] ? "\"#{delimiter}\"" : delimiter %>
<% yield %>
<%= delimiter %>

END_OF_TEMPLATE
# :startdoc:

# Makes a heredoc statement surrounding the contents of the block.  Options:
# 
#   delimiter   the delimiter used, by default HEREDOC_n where n increments
#   indent      add '-' before the delimiter
#   quote       quotes the delimiter
# 
# ==== HEREDOC ERB
#   <<<%= options[:indent] ? '-' : ' '%><%= options[:quote] ? "\"#{delimiter}\"" : delimiter %>
#   <% yield %>
#   <%= delimiter %>
def heredoc(options={})
  delimiter = options[:delimiter] || begin
    @heredoc_count ||= -1
    "HEREDOC_#{@heredoc_count += 1}"
  end
  eval(HEREDOC, binding, __FILE__, HEREDOC_LINE)
  nil
end

def _heredoc(*args, &block) # :nodoc:
  capture { heredoc(*args, &block) }
end

################################ not_if ################################

# 
def not_if(cmd, &block)
  only_if("! #{cmd}", &block)
end

def _not_if(*args, &block) # :nodoc:
  capture { not_if(*args, &block) }
end

############################### only_if ###############################

# :stopdoc:
ONLY_IF_LINE = __LINE__ + 2
ONLY_IF = "self." + ERB.new(<<'END_OF_TEMPLATE', nil, '<>').src
if <%= cmd %>
then
<% indent { yield } %>
fi

END_OF_TEMPLATE
# :startdoc:

# 
# ==== ONLY_IF ERB
#   if <%= cmd %>
#   then
#   <% indent { yield } %>
#   fi
def only_if(cmd)
  eval(ONLY_IF, binding, __FILE__, ONLY_IF_LINE)
  nil
end

def _only_if(*args, &block) # :nodoc:
  capture { only_if(*args, &block) }
end

########################### set_options ###########################

# :stopdoc:
SET_OPTIONS_LINE = __LINE__ + 2
SET_OPTIONS = "self." + ERB.new(<<'END_OF_TEMPLATE', nil, '<>').src
<% options.keys.sort_by {|opt| opt.to_s }.each do |opt| %>
set <%= options[opt] ? '-' : '+' %>o <%= opt %>
<% end %>
END_OF_TEMPLATE
# :startdoc:

# Sets the options to on (true) or off (false) as specified.
# ==== SET_OPTIONS ERB
#   <% options.keys.sort_by {|opt| opt.to_s }.each do |opt| %>
#   set <%= options[opt] ? '-' : '+' %>o <%= opt %>
#   <% end %>
def set_options(options)
  eval(SET_OPTIONS, binding, __FILE__, SET_OPTIONS_LINE)
  nil
end

def _set_options(*args, &block) # :nodoc:
  capture { set_options(*args, &block) }
end
end
end
end
