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
class ArticleLike < ApplicationRecord
  validates :user_id, uniqueness: { scope: :article_id }

  belongs_to :user
  belongs_to :article
end
