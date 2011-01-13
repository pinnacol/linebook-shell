Installs a file
(source, target, options={})
--
  only_if _file?(target) do
    backup target, :mv => true
  end
  
  directory File.dirname(target)
  cp source, target
  chmod options[:mode], target
  chown options[:user], options[:group], target
