class Api::V1::ArticleDetailSerializer < ActiveModel::Serializer
  attributes :id, :body, :updated_at
  belongs_to :user, serializer: Api::V1::UserSerializer
end
