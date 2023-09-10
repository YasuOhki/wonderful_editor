module Api::V1
  class ArticlesController < BaseApiController
    before_action :article_params, only: %i[ create ]
    # GET /article/1
    def show
      article = Article.find(params[:id])
      render json: article, serializer: Api::V1::ArticleDetailSerializer
    end

    # POST /article
    def create
      article = @current_user.articles.new(article_params)

      if article.save    # 「!」をつけるとelseには入らないので注意
        render json: article, serializer: Api::V1::ArticleCreateSerializer
      else
        render json: article.errors, status: 422
      end
    end

    private
      def article_params
        params.require(:article).permit(:title, :body, :user_id)
      end
  end
end
