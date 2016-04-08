require 'xinge'
Xinge.configure do |config|    
  config[:android_accessId] = 2100189459
  config[:android_secretKey] = '938abcacba4a963b10cfac167bbd211b'     
  config[:ios_accessId] = 2200190139  
  config[:ios_secretKey] = '148502c288e64f538e4b528fc5f59f23'   
  config[:env] = Rails.env # if you are not in a rails app, you can set it config[:env]='development' or config[:env]='production', it is 'development' default.
end