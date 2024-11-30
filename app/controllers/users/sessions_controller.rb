class Users::SessionsController < Devise::SessionsController
  respond_to :json

  private

  def respond_with(_resource, _opts = {})
    if current_user
      render json: {
        message: 'You are logged in.',
        user: current_user
      }, status: :ok
    else
      head :unauthorized
    end
  end

  def respond_to_on_destroy
    head user_from_token.present? ? :ok : :unauthorized
  end

  def user_from_token
    token = request.headers['Authorization']&.split(' ')&.second
    return if token.blank?

    jwt_payload = JWT.decode(token, ENV['DEVISE_JWT_SECRET_KEY']).first
    user_id = jwt_payload['sub']
    User.find(user_id.to_s)
  end
end
