class CheckPhoneController < ApplicationController

  def auth
    @user = User.find_by(phone: auth_params[:phone])
  end

  private

    def auth_params
      params.require(:check_phone).permit(:phone)
    end

end
