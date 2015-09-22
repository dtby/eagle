class Admin::BaseController < ApplicationController
	before_action :authenticate_admin!
  before_action :set_left_bar
  layout 'admin'


  private

  def set_left_bar
    @systems = System.includes(sub_systems: :patterns).all
  end
end
