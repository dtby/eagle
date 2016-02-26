class CheckPhoneController < ApplicationController
  protect_from_forgery :except => :auth
  def auth
    @user = User.find_by(phone: auth_params[:phone])
  end

  def auth_admin
    @admin = Admin.find_by(phone: auth_params[:phone])
  end

  private

    def auth_params
      params.require(:check_phone).permit(:phone)
    end

end
