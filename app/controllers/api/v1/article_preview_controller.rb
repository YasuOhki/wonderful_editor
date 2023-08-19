class V1::ArticlePreviewController < ApplicationController
  def index
    articles = Article.all.order(updated_at: "DESC")    # 更新日順に並び替え

    render json: articles
  end
