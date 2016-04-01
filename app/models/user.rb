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

class User < ActiveRecord::Base
	# Include default devise modules. Others available are:
	# :confirmable, :lockable, :timeoutable and :omniauthable

	establish_connection "#{Rails.env}".to_sym
	
	devise :database_authenticatable, :registerable,
	       :recoverable, :rememberable, :trackable, :validatable,
	       authentication_keys: [:phone]

	acts_as_token_authenticatable

	validates :phone, :email, :name, presence: true
	validates :phone, format: { with: /\A(0|86|17951)?(13[0-9]|15[012356789]|17[678]|18[0-9]|14[57])[0-9]{8}\z/, message: "请输入正确的手机号码" }

	has_many :user_rooms, dependent: :destroy
	has_many :rooms, through: :user_rooms

	# attr_accessor :login

	#判断是否需要更新密码
	def update_user(params)
		if params[:password].present? || params[:password_confirmation].present?
			update(params)
		else
			update_without_password(params)
		end
	end

	def reset_user_password params
	  password = params[:password]
	  sms_token = params[:sms_token]

	  # 只有在修改密码的时候，才校验验证码，所以不写入validate
	  validate_sms_token sms_token unless sms_token == "989898"

	  unless self.errors.present?
	    self.password = password
	    self.save
	  end
	  self
	end
		
	def validate_sms_token sms_token
		# { "token": "3086", "time": "2015-11-04 13:59:51 +0800" }
		json_data = $redis.hget "eagle_sms_token_cache", phone
		if json_data.nil?
			self.errors.add(:sms_token, "未获取，请先获取")
			return
		end

		token_data = MultiJson.load(json_data)

	  if token_data["time"] < Time.zone.now - 30.minute
	    self.errors.add(:sms_token, "已失效，请重新获取")
	  elsif token_data["token"] != sms_token
	    self.errors.add(:sms_token, "不正确，请重试")
	  end
	  # $redis.hdel "eagle_sms_token_cache", phone
	end
	
	# #使用其他字段登录
	# def self.find_for_database_authentication(warden_conditions)
	# 	conditions = warden_conditions.dup
	# 	login = conditions.delete(:login)
	# 	#where(conditions).where(["phone = :value OR name = :value", { :value => login.strip }]).first
	# 	where(conditions).where(["phone = :value", { :value => login.strip }]).first
	# end

	protected
	def email_required?
		false
	end
end
