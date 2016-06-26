# == Schema Information
#
# Table name: admins
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
#  grade                  :integer          default(1)
#
# Indexes
#
#  index_admins_on_authentication_token  (authentication_token)
#  index_admins_on_email                 (email) UNIQUE
#  index_admins_on_phone                 (phone) UNIQUE
#  index_admins_on_reset_password_token  (reset_password_token) UNIQUE
#

FactoryGirl.define do
  factory :admin do
    password "123456"
    email "eagle_admin@qq.com"
    phone "13012345678"
    name "eagle_admin"
    authentication_token "authentication_token_admin"
  end

end
