class User < ApplicationRecord
  # Fazendo isso pra quando precisar logar ou deslogar o user só inserir o token
  devise :database_authenticatable, :registerable,
         :jwt_authenticatable,
         jwt_revocation_strategy: JwtDenylist
end
