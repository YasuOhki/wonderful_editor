# == Schema Information
#
# Table name: article_likes
#
#  id         :bigint           not null, primary key
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  article_id :bigint           default(1), not null
#  user_id    :bigint           not null
#
# Indexes
#
#  index_article_likes_on_article_id              (article_id)
#  index_article_likes_on_user_id                 (user_id)
#  index_article_likes_on_user_id_and_article_id  (user_id,article_id) UNIQUE
#
# Foreign Keys
#
#  fk_rails_...  (article_id => articles.id)
#  fk_rails_...  (user_id => users.id)
#
require "rails_helper"

RSpec.describe ArticleLike, type: :model do
  context "article_idとuser_idの組み合わせが既存のレコードと異なるとき" do
    it "ArticleLikeの登録に成功する" do
      tmp_user = FactoryBot.create(:user)
      tmp_article = tmp_user.articles.create!(title: "test", body: "test")
      tmp_articlelike = ArticleLike.create!(user_id: tmp_user.id, article_id: tmp_article.id)
      expect(tmp_articlelike.valid?).to eq true
    end
  end

  context "article_idとuser_idの組み合わせが既存のレコードと同じとき" do
    it "ArticleLikeの登録に失敗する" do
      tmp_user = FactoryBot.create(:user)
      tmp_article = tmp_user.articles.create!(title: "test", body: "test")
      ArticleLike.create!(user_id: tmp_user.id, article_id: tmp_article.id)
      test_articlelike = ArticleLike.create(user_id: tmp_user.id, article_id: tmp_article.id)
      test_articlelike.persisted?
      expect(test_articlelike.errors.details[:user_id][0][:error]).to eq :taken
    end
  end
end
