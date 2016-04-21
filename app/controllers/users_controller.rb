# == Schema Information
#
# Table name: users
#
#  id                     :integer          not null, primary key
#  email                  :string(255)      default(""), not null
#  encrypted_password     :string(255)      default(""), not null
#  reset_password_token   :string(255)
#  reset_password_sent_at :datetime
#  remember_created_at    :datetime
#  sign_in_count          :integer          default(0), not null
#  current_sign_in_at     :datetime
#  last_sign_in_at        :datetime
#  current_sign_in_ip     :string(255)
#  last_sign_in_ip        :string(255)
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#  name                   :string(255)      default(""), not null
#  phone                  :string(255)      default(""), not null
#  authentication_token   :string(255)
#  os                     :string(255)
#  device_token           :string(255)
#
# Indexes
#
#  index_users_on_authentication_token  (authentication_token)
#  index_users_on_email                 (email) UNIQUE
#  index_users_on_phone                 (phone) UNIQUE
#  index_users_on_reset_password_token  (reset_password_token) UNIQUE
#

class UsersController < ApplicationController
  acts_as_token_authentication_handler_for User, only: [:show, :update_device]
  before_action :set_user, only: [:update_device]
  def show
  end

  def update_password
    @user = User.find_by(phone: user_params[:phone])
    return unless @user.present?
    @user.reset_user_password user_params
  end

  def update_device
    @user.update update_device_params
    XingeTagUpdateJob.set(queue: :message).perform_later @user.id
  end

  private
  def user_params
    params.require(:user).permit(:password, :sms_token, :phone)
  end

  def update_device_params
    params.require(:user).permit(:os, :device_token)
  end

  def set_user
    @user = User.find_by(phone: params[:user_phone])
  end
end
