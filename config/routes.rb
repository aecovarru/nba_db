Rails.application.routes.draw do
  resources :seasons do
    resources :games
    resources :teams do
      resources :players
    end
  end
end
