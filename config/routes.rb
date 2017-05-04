Rails.application.routes.draw do
  apipie
  root to: redirect('/apipie')

  namespace :api do
    namespace :v1 do
      resources :survivors, except: [:destroy]
      namespace :flag do
        post :infected
      end

      post :trade, to: 'trade#index', as: 'trade'
    end
  end
end
