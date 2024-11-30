Rails.application.routes.draw do
  devise_for :users,
             controllers: {
               sessions: 'users/sessions',
               registrations: 'users/registrations'
             }
  get '/member-data', to: 'members#show'
  root 'pages#home' # Define a rota raiz para pages#home
  get 'pages/home'
end
