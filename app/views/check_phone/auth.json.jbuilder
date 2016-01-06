if @user.present?
  json.extract! @user, :phone, :authentication_token
else
  json.errors "用户不存在"
end