if @admin.present?
  json.extract! @admin, :phone, :authentication_token
else
  json.errors "该管理员不存在"
end