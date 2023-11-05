module Api::V1
  class ArticlesController < BaseApiController
    def index
      articles = Article.all.order(updated_at: "DESC")    # 更新日順に並び替え

      render json: articles,
             each_serializer: Api::V1::ArticlePreviewSerializer
    end

    # GET /article/1
    def show
      article = Article.find(params[:id])
      render json: article, serializer: Api::V1::ArticleDetailSerializer
    end

    # POST /article
    def create
      @current_user = User.find(params[:article][:user_id])
      article = @current_user.articles.new(article_params)

      article.save!
      render json: article, serializer: Api::V1::ArticleCreateSerializer
    end

    # PATCH /articles/:id
    def update
      article = current_user.articles.find(params[:id])
      article.update!(article_params)
      render json: article, serializer: Api::V1::ArticleDetailSerializer
    end

    # DELETE /articles/:id
    def destroy
      article = current_user.articles.find(params[:id])
      article.destroy!
      render json: article, serializer: Api::V1::ArticleDetailSerializer
    end

    private

      def article_params
        params.require(:article).permit(:title, :body, :user_id)
      end
  end
end
