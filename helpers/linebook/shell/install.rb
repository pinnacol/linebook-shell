Installs a file
(source, target, options={})
--
  prepare target
  cp source, target
  chmod options[:mode], target
  chown options[:user], options[:group], target
  