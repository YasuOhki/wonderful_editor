class ArticlePreviewSerializer < ActiveModel::Serializer
  attributes :id, :title, :user_id

  has_many :comments
  has_many :article_likes
end
