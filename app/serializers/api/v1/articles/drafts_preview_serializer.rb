class Api::V1::Articles::DraftsPreviewSerializer < ActiveModel::Serializer
  attributes :id, :title, :body, :created_at, :status
  belongs_to :user, serializer: Api::V1::UserSerializer
end
