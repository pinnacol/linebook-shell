Installs a file
(source, target, options={})
--
  only_if _file?(target) do
    backup target
  end
  
  target_dir = File.dirname(target)
  not_if _directory?(target_dir) do
    mkdir_p target_dir
  end
  
  cp source, target
  chmod options[:mode], target
  chown options[:user], options[:group], target
  