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

      namespace :reports do
        get '/' => :index

        namespace :items do
          get '/' => :index
          get :water
          get :food
          get :medication
          get :ammo
          get :lost
        end

        namespace :survivors do
          get '/' => :index
          get :infected
          get :healthy
        end
      end
    end
  end
end
