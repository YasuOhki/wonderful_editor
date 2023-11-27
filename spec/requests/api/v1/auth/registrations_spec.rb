require "rails_helper"

RSpec.describe "Api::V1::Auth::Registrations", type: :request do
  describe "POST /v1/auth" do
    # subject { post(api_v1_user_session_path, params: params) }
    subject { post(api_v1_user_registration_path, params: params) }

    let(:params) { attributes_for(:user) }

    context "正しいパラメータを入力したとき" do
      it "ユーザ登録に成功する" do
        expect { subject }.to change { User.count }.by(1)
        expect(response).to have_http_status(:ok)
        header = response.headers
        expect(header).not_to be_empty
        expect(header["access-token"]).to be_present
      end
    end

    context "入力パラメータに必要なキー(name)が入っていないとき" do
      it "validationエラーでユーザ登録に失敗する" do
        params.delete(:name)
        expect { subject }.not_to change { User.count }
        expect(response).to have_http_status(:unprocessable_entity) # 422
      end
    end

    context "入力パラメータは適切だが既にDBに存在するとき" do
      it "ユーザ登録に失敗する" do
        subject # まず何かをDBに登録する
        test_user = params
        post(api_v1_user_registration_path, params: test_user) # DBに存在するレコードと同じものを登録しようとする
        expect { subject }.not_to change { User.count }
        expect(response).to have_http_status(:unprocessable_entity) # 422
      end
    end
  end
end
