Rails.application.routes.draw do
  apipie

  root to: redirect('/apipie')
  namespace :api do
    namespace :v1 do
      resources :survivors, except: [:destroy]
    end
  end
end
