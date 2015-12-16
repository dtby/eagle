class MacCode

  #对mac地址进行加密
  def self.encrypt_macaddr
    mac_addr = "dtby" + Mac.addr.to_s + "tec"
    Digest::MD5.hexdigest(mac_addr)
  end

  #从文件中读取lience信息
  def self.get_lience
    file = "#{Rails.root}/lience"
    line = ""
    File.open(file, "r").each_line do |l|
      l.slice!("\n")  #清除string中自动生成\n
      line = line + l
    end
    line
  end
end