class Api::V1::BaseApiController < ApplicationController
  protect_from_forgery with: :null_session
  before_action :set_user

  private

    def set_user
      @current_user = User.first   # 仮実装
    end
end
