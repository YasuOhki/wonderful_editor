module Api::V1
  class ArticlePreviewController < BaseApiController
    def index
      articles = Article.all.order(updated_at: "DESC")    # 更新日順に並び替え

      render json: articles,
             each_serializer: Api::V1::ArticlePreviewSerializer
    end
  end
end
