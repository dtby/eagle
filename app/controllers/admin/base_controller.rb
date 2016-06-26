class Admin::BaseController < ApplicationController
  before_action :authenticate_admin!, :set_left_bar
  
  # 侧边栏所有菜单
  def set_left_bar
    @systems = System.includes(sub_systems: :patterns).all
  end

  rescue_from CanCan::AccessDenied do |e|
    flash[:error] = '没有权限访问该页面'
    redirect_to admin_root_path
  end

  private
  def current_ability
    @current_ability ||= Ability.new(current_admin)
  end
end
