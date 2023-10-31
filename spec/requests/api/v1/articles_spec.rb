require "rails_helper"

RSpec.describe "Api::V1::Articles", type: :request do
  describe "GET / Api_v1_articles" do
    subject { get(api_v1_article_path(article_id)) }

    context "Articleクラスにレコードがあるとき" do
      it "更新日時順に設定したカラムが表示されること" do
        tmp_user = FactoryBot.create(:user)
        tmp_user.articles.create!(title: "test1", body: "test1")
        tmp_user.articles.create!(title: "test2", body: "test2")
        tmp_user.articles.create!(title: "test3", body: "test3")
        get api_v1_article_preview_index_path
        expect(tmp_user.articles.count).to be > 0
        expect(response).to have_http_status(:ok)
      end
    end

    context "Articleクラスにレコードがないとき" do
      it "エラーではなく空白のページが表示されること" do
        tmp_user = FactoryBot.create(:user)
        get api_v1_article_preview_index_path
        expect(tmp_user.articles.count).to eq 0
        expect(response).to have_http_status(:ok)
      end
    end

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

  describe "POST /api_v1_articles" do
    subject { post(api_v1_articles_path, params: params) }

    let(:params) { { article: attributes_for(:article) } }
    let(:current_user) { FactoryBot.create(:user) }
    before { allow_any_instance_of(Api::V1::BaseApiController).to receive(:current_user).and_return(current_user) }

    context "正常なtitleとbodyとuser_idを渡したとき" do
      it "その記事のレコードが作成できる" do
        params[:article][:user_id] = current_user.id.to_s

        subject
        res = JSON.parse(response.body)
        expect(response).to have_http_status(:ok)
        expect(res["user"]["id"].to_i).to eq params[:article][:user_id].to_i
        expect(res["title"]).to eq params[:article][:title]
      end
    end

    context "既存の内容と同じtitleを作成使用としたとき" do
      it "記事が作成できない" do
        tmp_user = FactoryBot.create(:user)
        tmp_article = tmp_user.articles.create!(title: "test", body: "test")
        params[:article][:title] = tmp_article[:title]    # 既存のtitleと同じにする
        params[:article][:user_id] = current_user.id.to_s

        expect { subject }.to raise_error ActiveRecord::RecordInvalid
      end
    end
  end

  describe "PATCH /api/v1/articles/:id" do
    let(:current_user) { FactoryBot.create(:user) }
    before { allow_any_instance_of(Api::V1::BaseApiController).to receive(:current_user).and_return(current_user) }

    context "正常なパラメータを渡したとき" do
      subject { patch(api_v1_article_path(test_article.id), params: params) }

      let(:params) { { article: attributes_for(:article) } }
      let(:test_article) { Article.create!(title: "test_title", body: "test_body", user: current_user) }

      it "記事が更新できる" do
        expect { subject }.to change { test_article.reload.title }.from(test_article.title).to(params[:article][:title])
        expect(response).to have_http_status(:ok)
      end
    end

    context "更新後のtitleが既に存在するとき" do
      subject { patch(api_v1_article_path(test_article.id), params: params) }

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
      subject { patch(api_v1_article_path(test_article.id), params: params) }

      let(:params) do
        { article: { title: "update_title", body: "" } }
      end
      let(:test_article) { current_user.articles.create!(title: "test_title", body: "test_body") }

      it "validationエラーで記事の更新に失敗する" do
        expect { subject }.to raise_error ActiveRecord::RecordInvalid
      end
    end
  end

  describe "DELETE /api/v1/articles/:id" do
    # subject { delete(api_v1_article_path(article_id)) }
    before { allow_any_instance_of(Api::V1::BaseApiController).to receive(:current_user).and_return(current_user) }

    context "存在するユーザに紐づく記事を削除したとき" do
      subject { delete(api_v1_article_path(article_id)) }

      let(:current_user) { FactoryBot.create(:user) }
      let(:article_id) { article.id }
      let(:article) { FactoryBot.create(:article, user: current_user) }

      it "該当記事の削除に成功する" do
        subject
        expect(response).to have_http_status(:ok)
      end
    end

    context "存在するユーザであるがそのユーザに紐づかない記事を削除しようとしたとき" do
      subject { delete(api_v1_article_path(article_id)) }

      let(:current_user) { FactoryBot.create(:user) }
      let(:article) { FactoryBot.create(:article, user: current_user) }
      let(:other_user) { FactoryBot.create(:user) }
      let(:other_article) { FactoryBot.create(:article, user: other_user) }
      let(:article_id) { other_article.id }

      it "該当記事の削除に失敗する" do
        expect { subject }.to raise_error ActiveRecord::RecordNotFound
      end
    end
  end
end
