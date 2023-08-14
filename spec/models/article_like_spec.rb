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
#  index_article_likes_on_article_id  (article_id)
#  index_article_likes_on_user_id     (user_id)
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
    end
  end

  context "aarticle_idとuser_idの組み合わせが既存のレコードと同じとき" do
    it "ArticleLikeの登録に失敗する" do
    end
  end
end
