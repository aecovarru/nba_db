Rails.application.routes.draw do
  root 'access#login'
  resources :seasons do
    resources :games
    resources :teams do
      resources :players
    end
  end
  match ':controller(/:action(/:id))', :via => [:get, :post]
end
