require 'xinge'
Xinge.configure do |config|    
  config[:android_accessId] = 2100189459
  config[:android_secretKey] = '938abcacba4a963b10cfac167bbd211b'     
  config[:ios_accessId] = 2200189460  
  config[:ios_secretKey] = 'bc60a87a888800a9167a84ad906e41ef'   
  config[:env] = Rails.env # if you are not in a rails app, you can set it config[:env]='development' or config[:env]='production', it is 'development' default.
end