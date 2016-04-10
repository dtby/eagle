class AdminBaseController < ApplicationController
  before_action :authenticate_admin!, :set_left_bar
  
  # 侧边栏所有菜单
  def set_left_bar
    @systems = System.includes(sub_systems: :patterns).all
  end
end
