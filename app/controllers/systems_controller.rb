# == Schema Information
#
# Table name: systems
#
#  id         :integer          not null, primary key
#  sys_name   :string(255)
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class SystemsController < ApplicationController

  acts_as_token_authentication_handler_for User, only: [:index]

  def index
    if params[:room_id].present?
      @systems = Room.find_by(id: params[:room_id]).try(:systems)
    else
      @systems = System.all
    end
  end
end
