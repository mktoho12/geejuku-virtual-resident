Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  get '/callback' => 'webhook#callback_subscribe'
  post '/callback' => 'webhook#callback'
end
