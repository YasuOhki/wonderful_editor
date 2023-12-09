require "rails_helper"

RSpec.describe "Api::V1::Auth::sessions", type: :request do
  describe "POST /v1/auth/sign_in" do
    subject { post(api_v1_user_session_path, params: params) }

    let!(:first_user) { FactoryBot.create(:user) }

    context "正しい内容で必要な全てのパラメータを入力したとき" do
      let!(:params) do
        { email: first_user.email, password: first_user.password, name: first_user.name }
      end
      it "ログインに成功する" do
        subject
        expect(response).to have_http_status(:ok) # 200
      end
    end

    context "入力パラメータ数は合っているがDBに登録されている内容でないとき" do
      let!(:params) do
        { email: "test", password: first_user.password, name: first_user.name }
      end
      it "ログインに失敗する" do
        subject
        expect(response).to have_http_status(:unauthorized) # 401
      end
    end

    context "入力内容は合っているが必要なカラムが不足しているとき" do
      let!(:params) do
        { email: first_user.email }
      end
      it "ログインに失敗する" do
        subject
        expect(response).to have_http_status(:unauthorized) # 401
      end
    end
  end

  describe "POST /v1/auth/sign_out" do
    subject { delete(destroy_api_v1_user_session_path, headers: headers) }

    context "ログアウトに必要なヘッダ情報が揃っているとき" do
      let(:first_user) { FactoryBot.create(:user) }
      let!(:headers) { first_user.create_new_auth_token }

      it "ログアウトに成功する" do
        expect { subject }.to change { first_user.reload.tokens }.from(be_present).to(be_blank)
        res = JSON.parse(response.body)
        expect(response).to have_http_status(:ok) # 200
        expect(res["success"]).to eq true
      end
    end

    context "ログアウトに必要なヘッダ情報が不足しているとき(uidがない)" do
      let(:first_user) { FactoryBot.create(:user) }
      let!(:headers) { first_user.create_new_auth_token.merge(uid: "") }

      it "ログアウトに失敗する" do
        subject
        res = JSON.parse(response.body)
        expect(res["success"]).to eq false
        expect(res["errors"]).to include "User was not found or was not logged in."
      end
    end
  end
end
