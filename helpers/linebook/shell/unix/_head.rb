require 'linebook/shell/posix'
include Posix

def shell_path
  @shell_path ||= '/bin/sh'
end

def env_path
  @env_path ||= '/usr/bin/env'
end

def target_path(source_path)
  '$LINECOOK_DIR/%s' % super(source_path)
end

def close
  unless closed?
    section " (#{target_name}) "
  end
  
  super
end