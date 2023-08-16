# == Schema Information
#
# Table name: articles
#
#  id         :bigint           not null, primary key
#  body       :text
#  title      :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  user_id    :bigint           default(1), not null
#
# Indexes
#
#  index_articles_on_title    (title) UNIQUE
#  index_articles_on_user_id  (user_id)
#
# Foreign Keys
#
#  fk_rails_...  (user_id => users.id)
#
require "rails_helper"

RSpec.describe Article, type: :model do
  context "titleとbodyが空でなく、ユニークであるとき" do
    it "Articleの登録に成功する" do
      tmp_user = FactoryBot.create(:user)
      tmp_article = tmp_user.articles.create!(title: "test", body: "test")
      expect(tmp_article.valid?).to eq true
    end
  end

  context "titleが空のとき" do
    it "Articleの登録に失敗する" do
      tmp_user = FactoryBot.create(:user)
      tmp_article = tmp_user.articles.create(title: "", body: "testtest")
      tmp_article.persisted?
      expect(tmp_article.valid?).to eq false
      expect(tmp_article.errors.details[:title][0][:error]).to eq :blank
    end
  end

  context "bodyが空のとき" do
    it "Articleの登録に失敗する" do
      tmp_user = FactoryBot.create(:user)
      tmp_article = tmp_user.articles.create(title: "test", body: "")
      tmp_article.persisted?
      expect(tmp_article.valid?).to eq false
      expect(tmp_article.errors.details[:body][0][:error]).to eq :blank
    end
  end

  context "titleが既存のものと同じであるとき" do
    it "Articleの登録に失敗する" do
      tmp_user = FactoryBot.create(:user)
      tmp_user.articles.create!(title: "test", body: "test")
      test_article = tmp_user.articles.create(title: "test", body: "test2")
      test_article.persisted?
      expect(test_article.valid?).to eq false
      expect(test_article.errors.details[:title][0][:error]).to eq :taken
    end
  end
end
