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
class Article < ApplicationRecord
  validates :title, presence: true, uniqueness: {case_sensitive: false}
  validates :body, presence: true, uniqueness: {case_sensitive: false}

  has_many :comments, dependent: :restrict_with_exception
  has_many :article_likes, dependent: :restrict_with_exception
  belongs_to :user
end
