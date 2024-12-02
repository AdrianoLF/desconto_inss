Rails.application.routes.draw do
  devise_for :users,
             controllers: {
               sessions: 'users/sessions',
               registrations: 'users/registrations'
             }
  root 'pages#home' # Define a rota raiz para pages#home

  namespace :api, defaults: { format: 'json' } do
    namespace :v1 do
      resource :members, only: [:show]
      resources :proponents, only: %i[index update create destroy]

      resources :inss_calculations, only: [] do
        collection do
          post :disccount
        end
      end
    end
  end

  get '*path', to: 'pages#home', constraints: ->(req) { !req.xhr? && req.format.html? }
end
