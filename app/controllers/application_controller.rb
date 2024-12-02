class ApplicationController < ActionController::Base
  skip_before_action :verify_authenticity_token
  before_action :authenticate_user!

  private

  def user
    @user ||= fetch_user_from_token
  end

  def fetch_user_from_token
    jwt_payload = JWT.decode(request.headers['Authorization']&.split(' ')&.second,
                             ENV['DEVISE_JWT_SECRET_KEY']).first
    user_id = jwt_payload['sub']
    User.find(user_id.to_s)
  end
end
