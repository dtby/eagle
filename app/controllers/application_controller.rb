class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  before_action :validate_mac_code

  private
  def validate_mac_code
    if MacCode.encrypt_macaddr !=  MacCode.get_lience
      return render text: "权限验证失败，详情联系开系统提供商！"
    end
  end
end
