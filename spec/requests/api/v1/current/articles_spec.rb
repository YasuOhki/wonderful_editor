require "rails_helper"

RSpec.describe "Api::V1::Current::Articles", type: :request do
  # index
  describe "GET /  api/v1/current/articles" do
    subject { get(api_v1_current_articles_path, headers: headers) }

    let(:current_user) { FactoryBot.create(:user) }
    let(:headers) { current_user.create_new_auth_token }

    context "存在するユーザでログインして一覧表示を指定したとき" do
      it "statusがdraftの記事が表示される(0個の場合)" do
        subject
        res = JSON.parse(response.body)
        expect(response).to have_http_status(:ok)
        expect(res.count).to eq 0
      end

      it "statusがdraftの記事が表示される(3個の場合)" do
        FactoryBot.create(:article, status: "published", user: current_user)
        FactoryBot.create(:article, status: "published", user: current_user)
        FactoryBot.create(:article, status: "published", user: current_user)
        FactoryBot.create(:article, user: current_user)

        subject
        res = JSON.parse(response.body)
        expect(response).to have_http_status(:ok)
        expect(res.count).to eq 3
      end
    end

    context "ログインせずにDraftsControllerにアクセスしたとき" do
      it "アクセスエラーとなる" do
        FactoryBot.create(:article, user: current_user)
        get(api_v1_current_articles_path)

        expect(response).to have_http_status(:unauthorized)
      end
    end
  end
end
