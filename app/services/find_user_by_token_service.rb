class FindUserByTokenService
  def perform(jwt_token)
    return if jwt_token.blank?

    jwt_payload = JWT.decode(jwt_token, ENV['DEVISE_JWT_SECRET_KEY']).first
    user_id = jwt_payload['sub']
    User.find(user_id.to_s)
  end
end
