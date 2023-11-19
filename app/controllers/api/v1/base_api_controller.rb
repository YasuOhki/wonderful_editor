class Api::V1::BaseApiController < ApplicationController
  before_action :current_user

  private

    def current_user
      @current_user = User.first   # 仮実装
    end
end
