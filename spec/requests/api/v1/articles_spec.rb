require "rails_helper"

RSpec.describe "Api::V1::Articles", type: :request do
  # index
  describe "GET / Api_v1_articles" do
    subject { get(api_v1_articles_path) }

    context "Articleクラスにレコードがあるとき" do
      it "更新日時順に設定したカラムが表示されること" do
        tmp_user = FactoryBot.create(:user)
        tmp_user.articles.create!(title: "test1", body: "test1")
        tmp_user.articles.create!(title: "test2", body: "test2")
        tmp_user.articles.create!(title: "test3", body: "test3")
        subject
        expect(tmp_user.articles.count).to be > 0
        expect(response).to have_http_status(:ok)
      end
    end

    context "Articleクラスにレコードがないとき" do
      it "エラーではなく空白のページが表示されること" do
        tmp_user = FactoryBot.create(:user)
        subject
        expect(tmp_user.articles.count).to eq 0
        expect(response).to have_http_status(:ok)
      end
    end

    context "statusがdraftの記事を1つとpublishedの記事を2つ作成したとき" do
      it "一覧に2つだけ記事が表示されること" do
        FactoryBot.create(:article) # あえてstatus指定しない(デフォルトがdraft)
        FactoryBot.create(:article, status: "published")
        FactoryBot.create(:article, status: "published")
        subject
        res = JSON.parse(response.body)
        expect(response).to have_http_status(:ok)
        expect(res.count).to eq Article.where(status: "published").count
        expect(res.count).not_to eq Article.count # statusがdraftのレコードを含めた数とは一致しない
      end
    end
  end

  # show
  describe "GET / Api_v1_article" do
    subject { get(api_v1_article_path(article_id)) }

    context "指定したidの記事が存在するとき" do
      let(:tmp_user) { FactoryBot.create(:user) }
      let(:tmp_article) { tmp_user.articles.create(title: "test", body: "test") }
      let(:article_id) { tmp_article.id }
      it "その記事のレコードが取得できる" do
        subject
        res = JSON.parse(response.body)
        expect(response).to have_http_status(:ok)
        expect(res["body"]).to eq tmp_article.body
        expect(res["user"]["id"]).to eq tmp_article.user_id
        expect(res["user"]["name"]).to eq tmp_article.user.name
        expect(res["user"]["email"]).to eq tmp_article.user.email
      end
    end

    context "指定したidの記事が存在しないとき" do
      let(:article_id) { 0 }
      it "記事が見つからない" do
        expect { subject }.to raise_error ActiveRecord::RecordNotFound
      end
    end
  end

  # create
  describe "POST /api_v1_articles" do
    subject { post(api_v1_articles_path, params: params, headers: headers) }

    let(:current_user) { FactoryBot.create(:user) }
    let(:headers) { current_user.create_new_auth_token }

    context "正常なtitleとbodyとuser_idを渡したとき" do
      let(:params) { { article: attributes_for(:article) } }
      it "その記事のレコードが作成できる" do
        subject
        res = JSON.parse(response.body)
        expect(response).to have_http_status(:ok)
        expect(res["title"]).to eq params[:article][:title]
      end
    end

    context "既存の内容と同じtitleを作成使用としたとき" do
      let(:params) { { article: attributes_for(:article) } }
      it "記事が作成できない" do
        tmp_user = FactoryBot.create(:user)
        tmp_article = tmp_user.articles.create!(title: "test", body: "test")
        params[:article][:title] = tmp_article[:title] # 既存のtitleと同じにする
        expect { subject }.to raise_error ActiveRecord::RecordInvalid
      end
    end

    context "statusをdraftに設定したとき" do
      let(:params) { { article: attributes_for(:article, status: "draft") } }
      it "statusがdraftの記事が作成できる" do
        subject
        res = JSON.parse(response.body)
        expect(response).to have_http_status(:ok)
        expect(res["status"]).to eq "draft"
      end
    end

    context "statusをpublishdedに設定したとき" do
      let(:params) { { article: attributes_for(:article, status: "published") } }
      it "statusがpublishedの記事が作成できる" do
        subject
        res = JSON.parse(response.body)
        expect(response).to have_http_status(:ok)
        expect(res["status"]).to eq "published"
      end
    end

    context "statusを指定しなかったとき" do
      let(:params) { { article: attributes_for(:article) } }
      it "statusがdraftの記事が作成できる" do
        subject
        res = JSON.parse(response.body)
        expect(response).to have_http_status(:ok)
        expect(res["status"]).to eq "draft"
      end
    end
  end

  # update
  describe "PATCH /api/v1/articles/:id" do
    subject { patch(api_v1_article_path(test_article.id), params: params, headers: headers) }

    let(:headers) { current_user.create_new_auth_token }
    let(:current_user) { FactoryBot.create(:user) }

    context "正常なパラメータを渡したとき" do
      let(:params) { { article: attributes_for(:article) } }
      let(:test_article) { Article.create!(title: "test_title", body: "test_body", user: current_user) }

      it "記事が更新できる" do
        expect { subject }.to change { test_article.reload.title }.from(test_article.title).to(params[:article][:title])
        expect(response).to have_http_status(:ok)
      end
    end

    context "更新後のtitleが既に存在するとき" do
      let(:params) do
        { article: { title: "pre_test_title", body: "update_body" } }
      end
      let(:test_article) { current_user.articles.create!(title: "test_title", body: "test_body") }

      it "validationエラーで記事の更新に失敗する" do
        current_user.articles.create!(title: "pre_test_title", body: "pre_test_body")
        expect { subject }.to raise_error(ActiveRecord::RecordInvalid)
      end
    end

    context "更新時に空のカラムを渡したとき" do
      let(:params) do
        { article: { title: "update_title", body: "" } }
      end
      let(:test_article) { current_user.articles.create!(title: "test_title", body: "test_body") }

      it "validationエラーで記事の更新に失敗する" do
        expect { subject }.to raise_error ActiveRecord::RecordInvalid
      end
    end

    context "statusをdraftからpublishedに設定したとき" do
      let(:params) { { article: attributes_for(:article, title: test_article.title, body: test_article.body, status: "published", user: current_user) } }
      let(:test_article) { Article.create!(title: "test_title", body: "test_body", user: current_user) }

      it "記事のstatusが更新される" do
        expect { subject }.to change { test_article.reload.status }.from(test_article.status).to(params[:article][:status])
        expect(response).to have_http_status(:ok)
      end
    end

    context "ログイン中のユーザ以外の記事を更新しようとしたとき" do
      let!(:dummy_user) { FactoryBot.create(:user) }
      let(:params) { { article: attributes_for(:article, title: test_article.title, body: test_article.body, status: "published", user: dummy_user) } }
      let(:test_article) { Article.create!(title: "test_title", body: "test_body", user: dummy_user) }

      it "記事の更新に失敗する" do
        expect { subject }.to raise_error ActiveRecord::RecordNotFound
      end
    end
  end

  # destroy
  describe "DELETE /api/v1/articles/:id" do
    subject { delete(api_v1_article_path(article_id), headers: headers) }

    let(:current_user) { FactoryBot.create(:user) }
    let(:headers) { current_user.create_new_auth_token }
    let(:article_id) { article.id }

    before { allow_any_instance_of(Api::V1::BaseApiController).to receive(:current_user).and_return(current_user) }

    context "存在するユーザに紐づく記事を削除したとき" do
      let!(:article) { FactoryBot.create(:article, user: current_user) }

      it "該当記事の削除に成功する" do
        subject
        expect(response).to have_http_status(:ok)
      end
    end

    context "存在するユーザであるがそのユーザに紐づかない記事を削除しようとしたとき" do
      let(:other_user) { FactoryBot.create(:user) }
      let!(:article) { FactoryBot.create(:article, user: other_user) }

      it "該当記事の削除に失敗する" do
        expect { subject }.to raise_error ActiveRecord::RecordNotFound
      end
    end
  end
end
