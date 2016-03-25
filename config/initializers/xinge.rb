require 'xinge'
Xinge.configure do |config|    
  config[:android_accessId] = 2100190140   
  config[:android_secretKey] = '42bb9334bdb2cab9d677eed0ca6d4caf'     
  config[:ios_accessId] = 2200120442  
  config[:ios_secretKey] = '1d5677036156dd7124493acc62783de0'   
  config[:env] = Rails.env # if you are not in a rails app, you can set it config[:env]='development' or config[:env]='production', it is 'development' default.
end