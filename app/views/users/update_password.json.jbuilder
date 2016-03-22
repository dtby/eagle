if @user.present?
  json.extract! @user, :id, :email, :created_at, :updated_at, :name, :phone, :authentication_token
else
  json.errors "用户不存在"
end