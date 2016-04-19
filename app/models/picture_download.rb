require 'net/ftp'
require 'yaml'

class PictureDownload

  def initialize
    @config = YAML.load_file('config/ftp.yml')
    @path = "public/monitor/"
    FileUtils.makedirs(@path) unless File.exist?(@path)

    @ftp = Net::FTP.new
  end

  def download start_time, end_time
    begin
      @ftp.connect(@config["url"], @config["port"])
    rescue Exception => e
      return "Exception is #{e}"
    end
    user = @config["user"] || "anonymous"
    passwd = @config["passwd"]

    @ftp.login(user, passwd)
    @ftp.chdir @config["path"]
    files = @ftp.nlst
    return "there is no file in this path" unless files.present?
    download_size = 0
    files.each do |file|
      time_strings = file.split("_")[2]
      time = time_strings.ljust(13, "0")
      if time >= start_time && time <= end_time
        puts file
        download_size += 1
        @ftp.get(file, "#{@path}#{file}")
      end
    end
    "#{download_size} files download"
  end

  def self.pic_list
    files = Dir.entries("public/monitor/")
    files.delete(".")
    files.delete("..")
    files.delete(".keep")
    files
  end

  def self.keyword(start_time, end_time)
    if start_time.present? and end_time.present?
      PictureDownload.new.download(start_time.strftime("%Y%m%d%H%M%S000"), end_time.strftime("%Y%m%d%H%M%S000"))
    end
    files = self.pic_list
    return files if start_time.blank? && end_time.blank?

    pics = []
    files.each do |file|
      created_time = file.split("_")[2].to_datetime
      if start_time <= created_time && created_time - 1.day<= end_time
        pics << file
      end
    end
    pics
  end
end
