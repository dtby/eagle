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
#
# Indexes
#
#  index_users_on_authentication_token  (authentication_token)
#  index_users_on_email                 (email) UNIQUE
#  index_users_on_phone                 (phone) UNIQUE
#  index_users_on_reset_password_token  (reset_password_token) UNIQUE
#

class User < ActiveRecord::Base
	# Include default devise modules. Others available are:
	# :confirmable, :lockable, :timeoutable and :omniauthable
	
	devise :database_authenticatable, :registerable,
	       :recoverable, :rememberable, :trackable, :validatable,
	       authentication_keys: [:phone]

	acts_as_token_authenticatable

	validates :phone, :email, :name, presence: true
	validates :phone, format: { with: /\A(0|86|17951)?(13[0-9]|15[012356789]|17[678]|18[0-9]|14[57])[0-9]{8}\z/, message: "请输入正确的手机号码" }

	has_many :user_rooms, dependent: :destroy
	has_many :rooms, through: :user_rooms

	attr_accessor :login

	#判断是否需要更新密码
	def update_user(params)
		if params[:password].present? || params[:password_confirmation].present?
			update(params)
		else
			update_without_password(params)
		end
	end

	#使用其他字段登录
	def self.find_for_database_authentication(warden_conditions)
		conditions = warden_conditions.dup
		login = conditions.delete(:login)
		#where(conditions).where(["phone = :value OR name = :value", { :value => login.strip }]).first
		where(conditions).where(["phone = :value", { :value => login.strip }]).first
	end

	protected
	def email_required?
		false
	end
end
