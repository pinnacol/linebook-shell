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

def to_opts(opts)
  if opts.nil? || opts.empty?
    return ''
  end
  
  args = [nil]
  
  opts.keys.sort.each do |key|
    opt = key.to_s
    
    unless opt[0] == ?-
      opt = opt.length == 1 ? "-#{opt}" : "--#{opt}"
    end
    
    args << opt
    args << opts[key]
  end
  
  args.join(' ')
end

def close
  unless closed?
    section " (#{target_name}) "
  end
  
  super
end