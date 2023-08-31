class Api::V1::ArticleDetailSerializer < ActiveModel::Serializer
  attributes :id, :body, :updated_at
end
