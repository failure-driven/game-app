Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  get '/' => 'landing#index'
  get '/profile' => 'landing#index'

  get '/game' => 'game#index'
end
