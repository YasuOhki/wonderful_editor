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
      tmp_comment = FactoryBot.build(:comment)
      expect(tmp_comment.valid?).to eq true
    end
  end

  context "bodyが空のとき" do
    it "Commentの登録に失敗する" do
      tmp_comment = Comment.new(body:"")
      expect(tmp_comment.valid?).to eq false
    end
  end
end
