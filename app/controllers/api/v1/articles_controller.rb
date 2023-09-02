module Api::V1
  class ArticlesController < BaseApiController
    def show
      article = Article.find(params[:id])
      render json: article, serializer: Api::V1::ArticleDetailSerializer
    end
  end
end
