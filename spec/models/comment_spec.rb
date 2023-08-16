# == Schema Information
#
# Table name: comments
#
#  id         :bigint           not null, primary key
#  body       :text
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  article_id :bigint           default(1), not null
#  user_id    :bigint           default(1), not null
#
# Indexes
#
#  index_comments_on_article_id  (article_id)
#  index_comments_on_user_id     (user_id)
#
# Foreign Keys
#
#  fk_rails_...  (article_id => articles.id)
#  fk_rails_...  (user_id => users.id)
#
require "rails_helper"

RSpec.describe Comment, type: :model do
  context "bodyが空でないとき" do
    it "Commentの登録に成功する" do
      tmp_user = FactoryBot.create(:user)
      tmp_article = tmp_user.articles.create!(title: "test", body: "test")
      tmp_comment = Comment.create!(body: "test_comment", user_id: tmp_user.id, article_id: tmp_article.id)
      expect(tmp_comment.valid?).to eq true
    end
  end

  context "bodyが空のとき" do
    it "Commentの登録に失敗する" do
      tmp_comment = Comment.create(body: "")
      tmp_comment.persisted?
      expect(tmp_comment.valid?).to eq false
      expect(tmp_comment.errors.errors[0].type).to eq :blank
    end
  end
end
