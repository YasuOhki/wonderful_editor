require "rails_helper"

RSpec.describe "Api::V1::Auth::Registrations", type: :request do
  describe "POST /v1/auth" do
    # subject { post(api_v1_user_session_path, params: params) }
    subject { post(api_v1_user_registration_path, params: params) }

    context "正しいパラメータを入力したとき" do
      let(:params) { attributes_for(:user) }

      it "ユーザ登録に成功する" do
        expect { subject }.to change { User.count }.by(1)
        expect(response).to have_http_status(:ok)
        header = response.headers
        expect(header).not_to be_empty
        expect(header["access-token"]).to be_present
      end
    end
  end
end
