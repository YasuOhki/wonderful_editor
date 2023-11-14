class Api::V1::Auth::RegistrationsController < DeviseTokenAuth::RegistrationsController
  protect_from_forgery with: :null_session

  private

  # 親クラスのsign_up_paramsメソッドをオーバーライドしている？
  def sign_up_params
    #params.require(:registration).permit(:name, :email, :password, :password_confirmation)
    params.require(:registration).permit(:email, :password)
  end
end
