class ApplicationController < ActionController::Base
  skip_before_action :verify_authenticity_token
  before_action :authenticate_user!

  private

  def user
    @user ||= fetch_user_from_token
  end

  def fetch_user_from_token
    token = request.headers['Authorization']&.split(' ')&.second
    FindUserByTokenService.new.perform(token)
  end
end
