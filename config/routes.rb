Rails.application.routes.draw do
  get 'admin', to: 'access#index'
  root 'access#index'
  resources :seasons do
    resources :games
    resources :teams do
      resources :players
    end
  end
  match ':controller(/:action(/:id))', :via => [:get, :post]
end
