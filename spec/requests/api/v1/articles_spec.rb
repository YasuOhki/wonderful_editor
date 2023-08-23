require "rails_helper"

RSpec.describe "Api::V1::Article", type: :request do
  describe "Articleクラスにレコードがあるとき" do
    it "更新日時順に設定したカラムが表示されること" do
      tmp_user = FactoryBot.create(:user)
      tmp_user.articles.create!(title: "test1", body: "test1")
      tmp_user.articles.create!(title: "test2", body: "test2")
      tmp_user.articles.create!(title: "test3", body: "test3")
      get api_v1_article_preview_index_path
      expect(tmp_user.articles.count).to be > 0
      expect(response).to have_http_status(:ok)
      binding.pry
    end
  end

  describe "Articleクラスにレコードがないとき" do
    it "エラーではなく空白のページが表示されること" do
      tmp_user = FactoryBot.create(:user)
      get api_v1_article_preview_index_path
      expect(tmp_user.articles.count).to eq 0
      expect(response).to have_http_status(:ok)
    end
  end
end
