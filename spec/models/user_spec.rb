# == Schema Information
#
# Table name: users
#
#  id                     :bigint           not null, primary key
#  allow_password_change  :boolean          default(FALSE)
#  confirmation_sent_at   :datetime
#  confirmation_token     :string
#  confirmed_at           :datetime
#  email                  :string
#  encrypted_password     :string           default(""), not null
#  name                   :string
#  provider               :string           default("email"), not null
#  remember_created_at    :datetime
#  reset_password_sent_at :datetime
#  reset_password_token   :string
#  tokens                 :json
#  uid                    :string           default(""), not null
#  unconfirmed_email      :string
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#
# Indexes
#
#  index_users_on_confirmation_token    (confirmation_token) UNIQUE
#  index_users_on_email                 (email) UNIQUE
#  index_users_on_reset_password_token  (reset_password_token) UNIQUE
#  index_users_on_uid_and_provider      (uid,provider) UNIQUE
#
require 'rails_helper'

RSpec.describe User, type: :model do
  context "passwordに英数字を使用しているとき(文字数は8文字以上)" do
    it "passwordの登録に成功する" do
      tmp_user = FactoryBot.build(:user)
      expect(tmp_user.valid?).to eq true
    end
  end

  context "passwordに英数字以外の文字を使用しているとき" do
    it "passwordの登録に失敗する" do
      tmp_user = User.new(name:"test", email: "test@example.com", password: "あああ")
      expect(tmp_user.valid?).to eq false
    end
  end

  context "passwordに英数字を使用しているとき(文字数は8文字未満)" do
    it "passwordの登録に失敗する" do
      tmp_user = User.new(name:"test", email: "test@example.com", password: "test")
      expect(tmp_user.valid?).to eq false
    end
  end
end
