Rails.application.routes.draw do
    # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
    match '/register' => 'user#register', via: [:get, :post]
    match '/login' => 'user#login', via: [:get, :post]
    match '/profile/:username' => 'user#profile', via: [:get]
    match '/profile' => 'user#profile', via: [:get]
    match '/logout' => 'user#logout', via: [:get]
end
