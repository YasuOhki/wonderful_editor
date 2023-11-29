class Api::V1::Auth::SessionsController < DeviseTokenAuth::SessionsController
  private

    def resource_params
      params.permit(:email, :password, :name)
    end
end
