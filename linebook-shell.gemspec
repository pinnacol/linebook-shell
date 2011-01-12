$:.unshift File.expand_path('../lib', __FILE__)
require 'linebook/shell/version'
$:.shift

Gem::Specification.new do |s|
  s.name     = 'linebook-shell'
  s.version  = Linebook::Shell::VERSION
  s.platform = Gem::Platform::RUBY
  s.author   = 'Simon Chiang'
  s.email    = 'simon.a.chiang@gmail.com'
  s.homepage = 'http://rubygems.org/gems/linebook-shell'
  s.summary  = 'Shell basics for Linecook'
  s.description = ''
  s.rubyforge_project = ''
  s.require_path = 'lib'
  
  s.has_rdoc = true
  s.rdoc_options.concat %W{--main README -S -N --title LinebookShell}
  
  # add dependencies
  s.add_dependency('linecook', '~> 0.9.1')
  
  # list extra rdoc files here.
  s.extra_rdoc_files = %W{
    History
    README
    License.txt
  }
  
  # list the files you want to include here.
  s.files = %W{
    cookbook
    lib/linebook/shell.rb
    lib/linebook/shell/bash.rb
    lib/linebook/shell/posix.rb
    lib/linebook/shell/unix.rb
    lib/linebook/shell/version.rb
  }
end