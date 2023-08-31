module Api::V1
  class ArticlePreviewController < BaseApiController
    def index
      articles = Article.all.order(updated_at: "DESC")    # 更新日順に並び替え

      render json: articles,
             each_serializer: Api::V1::ArticlePreviewSerializer
    end

    # GET /article/1
    def show
      article = Article.find(params[:id])
      render json: article,
             serializer: Api::V1::ArticleDetailSerializer
    end
  end
end
