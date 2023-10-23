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

    context "正常なtitleとbodyとuser_idを渡したとき" do
      let(:params) do
        { article: attributes_for(:article) }
      end

      it "その記事のレコードが作成できる" do
        def article_create_mock
          @current_user = FactoryBot.create(:user)
          params[:article][:user_id] = @current_user.id.to_s
        end

        allow_any_instance_of(Api::V1::BaseApiController).to receive(:set_user).and_return(article_create_mock)
        subject
        res = JSON.parse(response.body)
        expect(response).to have_http_status(:ok)
        expect(res["user"]["id"].to_i).to eq params[:article][:user_id].to_i
        expect(res["title"]).to eq params[:article][:title]
      end
    end

    context "既存の内容と同じtitleを作成使用としたとき" do
      let(:params) do
        { article: attributes_for(:article) }
      end
      it "記事が作成できない" do
        def article_create_mock
          tmp_user = FactoryBot.create(:user)
          tmp_article = tmp_user.articles.create!(title: "test", body: "test")

          @current_user = FactoryBot.create(:user)
          params[:article][:title] = tmp_article[:title]    # 既存のtitleと同じにする
          params[:article][:user_id] = @current_user.id.to_s
        end

        allow_any_instance_of(Api::V1::BaseApiController).to receive(:set_user).and_return(article_create_mock)
        expect { subject }.to raise_error ActiveRecord::RecordInvalid
      end
    end
  end

  describe "PATCH /api_v1_articles/:id" do
    subject { patch(api_v1_article_path(@test_article.id), params: params) }

    context "正常なパラメータを渡したとき" do
      let(:params) do
        { article: { title: "update_title", body: "update_body" } }
      end

      it "記事が更新できる" do
        def article_update_mock
          @current_user = FactoryBot.create(:user)
          @test_article = @current_user.articles.create!(title: "test_title", body: "test_body")
        end

        allow_any_instance_of(Api::V1::BaseApiController).to receive(:set_user).and_return(article_update_mock)

        expect { subject }.to change { Article.find(@test_article.id).title }.from(@test_article.title).to(params[:article][:title])
        JSON.parse(response.body)
        expect(response).to have_http_status(:ok)
      end
    end

    context "更新後のtitleが既に存在するとき" do
      let(:params) do
        { article: { title: "pre_test_title", body: "update_body" } }
      end

      it "validationエラーで記事の更新に失敗する" do
        def article_update_mock
          @test_article = @current_user.articles.create!(title: "test_title", body: "test_body")
        end

        @current_user = FactoryBot.create(:user)
        @current_user.articles.create!(title: "pre_test_title", body: "pre_test_body")
        allow_any_instance_of(Api::V1::BaseApiController).to receive(:set_user).and_return(article_update_mock)
        expect { subject }.to raise_error ActiveRecord::RecordInvalid
      end
    end

    context "更新時に空のカラムを渡したとき" do
      let(:params) do
        { article: { title: "update_title", body: "" } }
      end

      it "validationエラーで記事の更新に失敗する" do
        def article_update_mock
          @current_user = FactoryBot.create(:user)
          @test_article = @current_user.articles.create!(title: "test_title", body: "test_body")
        end

        allow_any_instance_of(Api::V1::BaseApiController).to receive(:set_user).and_return(article_update_mock)
        expect { subject }.to raise_error ActiveRecord::RecordInvalid
      end
    end
  end
end
