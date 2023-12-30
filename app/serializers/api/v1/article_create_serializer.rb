class Api::V1::ArticleCreateSerializer < ActiveModel::Serializer
  attributes :id, :title, :body, :created_at, :status
  belongs_to :user, serializer: Api::V1::UserSerializer
end
