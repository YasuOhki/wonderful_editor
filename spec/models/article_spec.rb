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
      tmp_article = FactoryBot.create(:article)
      binding.pry
      expect(tmp_article.valid?).to eq true
    end
  end

  context "titleが空のとき" do
    it "Articleの登録に失敗する" do
      tmp_article = Article.new(title:"", body:"testtest")
      expect(tmp_article.valid?).to eq false
    end
  end

  context "bodyが空のとき" do
    it "Articleの登録に失敗する" do
      tmp_article = Article.new(title:"test", body:"")
      expect(tmp_article.valid?).to eq false
    end
  end

  context "titleが既存のものと同じであるとき" do
    it "Articleの登録に失敗する" do
    end
  end

  context "bodyが既存のものと同じであるとき" do
    it "Articleの登録に失敗する" do
    end
  end
end
