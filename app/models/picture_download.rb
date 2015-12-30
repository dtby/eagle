require 'net/ftp'
require 'yaml'

class PictureDownload

  def self.start
    PictureDownload.init_data unless $ftp.present?
    $ftp.connect(@config["url"], @config["port"])
    $ftp.login

    
    $ftp.nlst.each do |file|
      $ftp.get(file, "#{@path}#{file}")
    end
  end
  
  def self.init_data
    @config = YAML.load_file('config/ftp.yml')
    @path = "app/assets/images/monitor/"
    FileUtils.makedirs(@path) unless File.exist?(@path)

    $ftp = Net::FTP.new
  end
end
