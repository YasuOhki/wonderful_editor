module Api::V1::Articles
  class DraftsController < Api::V1::BaseApiController
    before_action :authenticate_user!

    def index
      binding.pry
      drafts = current_user.articles.where(status: "draft")
      render json: drafts,
             each_serializer: Api::V1::Articles::DraftsPreviewSerializer
    end

    def show
      binding.pry
      draft_article = Article.find(params[:id])
      #draft_article = current_user.articles.find(params[:id])
      render json: draft_article, serializer: Api::V1::Articles::DraftsDetailSerializer
    end

    private
      def draft_params
        params.require(:article).permit(:title, :body, :status, :user_id)
      end
  end
end
