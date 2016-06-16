class ApplicationController < ActionController::Base
  respond_to :html, :json
  layout :get_layout

  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception


  def get_layout
    if params[:controller].include?("admin")
      'admin'
    elsif devise_controller?
      'login'
    else
      'application'
    end
  end
  
end
