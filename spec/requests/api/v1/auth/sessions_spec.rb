require "rails_helper"

RSpec.describe "Api::V1::Auth::sessions", type: :request do
  describe "POST /v1/auth/sign_in" do
    subject { post(api_v1_user_session_path, params: params) }

    context "正しい内容で必要な全てのパラメータを入力したとき" do
      it "ログインに成功する" do
        first_user = FactoryBot.create(:user)
        params = { email: first_user.email, password: first_user.password, name: first_user.name }
        # subject
        post(api_v1_user_session_path, params: params)
        expect(response).to have_http_status(:ok) # 200
      end
    end

    context "入力パラメータ数は合っているがDBに登録されている内容でないとき" do
      it "ログインに失敗する" do
        first_user = FactoryBot.create(:user)
        params = { email: "test", password: first_user.password, name: first_user.name }
        post(api_v1_user_session_path, params: params)
        expect(response).to have_http_status(:unauthorized) # 401
      end
    end

    context "入力内容は合っているが必要なカラムが不足しているとき" do
      it "ログインに失敗する" do
        first_user = FactoryBot.create(:user)
        params = { email: first_user.email }
        # subject
        post(api_v1_user_session_path, params: params)
        expect(response).to have_http_status(:unauthorized) # 401
      end
    end
  end
end
