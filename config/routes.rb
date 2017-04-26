Rails.application.routes.draw do
  apipie
  root to: redirect('/apipie')

  namespace :api do
    namespace :v1 do
      resources :survivors, except: [:destroy]
      post 'report_infection', to: 'survivors#report_infection', as: 'report_infection'
    end
  end
end
