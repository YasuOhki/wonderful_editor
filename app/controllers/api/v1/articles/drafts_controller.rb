module Api::V1
  class Articles::DraftsController < BaseApiController
    before_action :authenticate_user!

    def index
      drafts = current_user.articles.draft.order(updated_at: "DESC")    # 更新日順に並び替え
      render json: drafts,
             each_serializer: Api::V1::ArticlePreviewSerializer
    end

    def show
      draft_article = current_user.articles.draft.find(params[:id])
      render json: draft_article, serializer: Api::V1::ArticleDetailSerializer
    end

    private

      def draft_params
        params.require(:article).permit(:title, :body, :status, :user_id)
      end
  end
end
