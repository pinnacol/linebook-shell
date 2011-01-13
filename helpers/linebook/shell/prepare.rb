Prepares a file location to recieve a new file by making parent directories as
needed, and backing up the file if it already exists.
(target)
--
  only_if _file?(target) do
    backup target, :mv => true
  end
  
  target_dir = File.dirname(target)
  not_if _directory?(target_dir) do
    mkdir_p target_dir
  end