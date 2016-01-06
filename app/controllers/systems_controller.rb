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
    @systems = System.all
  end
end
