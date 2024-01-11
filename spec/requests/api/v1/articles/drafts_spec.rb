require "rails_helper"

RSpec.describe "Api::V1::Articles::Drafts", type: :request do
  # index
  describe "GET / Api_v1_articles/drafts" do
    subject { get(api_v1_articles_drafts_path, headers: headers) }

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
        FactoryBot.create(:article, user: current_user)
        FactoryBot.create(:article, user: current_user)
        FactoryBot.create(:article, user: current_user)
        FactoryBot.create(:article, status: "published", user: current_user)

        subject
        res = JSON.parse(response.body)
        expect(response).to have_http_status(:ok)
        expect(res.count).to eq 3
      end
    end

    context "ログインせずにDraftsControllerにアクセスしたとき" do
      it "アクセスエラーとなる" do
        FactoryBot.create(:article, user: current_user)
        get(api_v1_articles_drafts_path)

        expect(response).to have_http_status(:unauthorized)
      end
    end
  end

  # show
  describe "GET / Api_v1_article/drafts" do
    subject { get(api_v1_articles_draft_path(article_id), headers: headers) }

    let(:current_user) { FactoryBot.create(:user) }
    let(:tmp_article) { FactoryBot.create(:article, user: current_user) }
    let(:article_id) { tmp_article.id }
    let(:headers) { current_user.create_new_auth_token }

    context "存在するユーザでログインして存在する記事のidを指定したとき" do
      it "記事の詳細が表示される" do
        subject

        res = JSON.parse(response.body)
        expect(response).to have_http_status(:ok)
        expect(res["title"]).to eq tmp_article.title
        expect(res["body"]).to eq tmp_article.body
        expect(res["status"]).to eq tmp_article.status
      end
    end

    context "存在するユーザでログインして存在しない記事のidを指定したとき" do
      it "記事の詳細が表示されない" do
        dummy_id = 999
        expect { get(api_v1_articles_draft_path(dummy_id), headers: headers) }.to raise_error ActiveRecord::RecordNotFound
      end
    end
  end
end
