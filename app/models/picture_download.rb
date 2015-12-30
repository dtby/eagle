require 'net/ftp'
require 'yaml'

class PictureDownload

  def self.download start_time, end_time
    PictureDownload.init_data # unless @ftp.present?
    begin
      @ftp.connect(@config["url"], @config["port"])  
    rescue Exception => e
      return "Exception is #{e}"
    end
    
    @ftp.login
    @ftp.chdir @config["path"]
    files = @ftp.nlst
    return "there is no file in this path" unless files.present?
    download_size = 0
    files.each do |file|
      time_strings = file.split("_")[2]
      time = time_strings.ljust(13, "0")
      if time > start_time && time < end_time
        puts file
        download_size += 1
        @ftp.get(file, "#{@path}#{file}")
      end
    end
    "#{download_size} files download"
  end
  
  def self.init_data
    @config = YAML.load_file('config/ftp.yml')
    @path = "app/assets/images/monitor/"
    FileUtils.makedirs(@path) unless File.exist?(@path)

    @ftp = Net::FTP.new
  end
end
