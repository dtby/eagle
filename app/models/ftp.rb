require 'yaml'

class Ftp
  #Ftp.genate_ftp_config("user", "passwd", "url", "port", "path")
  def self.genate_ftp_config(user, passwd, url, port, path)
    hash = {
      "user" => user,
      "passwd" => passwd,
      "url" => url,
      "port" => port,
      "path" => path,
    }
    File.open('config/ftp.yml', 'w') {|f| f.write hash.to_yaml }
  end

  def self.get_ftp_config
    YAML.load_file('config/ftp.yml')
  end
end