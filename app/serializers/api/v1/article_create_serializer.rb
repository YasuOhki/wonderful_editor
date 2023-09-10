class Api::V1::ArticleCreateSerializer < ActiveModel::Serializer
  attributes :id, :title, :body, :created_at
  belongs_to :user, serializer: Api::V1::UserSerializer
end
