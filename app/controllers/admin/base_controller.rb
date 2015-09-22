class Admin::BaseController < ApplicationController
	layout 'admin'
	before_action :authenticate_admin!
	before_action :set_left_bar

  private

  def set_left_bar
    @systems = System.includes(sub_systems: :patterns).all
  end
end
