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
      @sub_systems = Room.find_by(id: params[:room_id]).try(:sub_systems).to_a
      @systems = @sub_systems.collect { |ss| ss.system }.uniq
    else
      @systems = System.all
    end
  end
end
