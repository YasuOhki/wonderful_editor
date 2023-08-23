class Api::V1::ArticlePreviewSerializer < ActiveModel::Serializer
  attributes :id, :title, :user_id

  belongs_to :user, serializer: Api::V1::UserSerializer
end
