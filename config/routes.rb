Rails.application.routes.draw do
    # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
    match '/register' => 'users#register', via: [:get, :post]
    match '/login' => 'users#login', via: [:get, :post]
    match '/profile/:username' => 'users#profile', via: [:get]
    match '/profile' => 'users#profile', via: [:get]
    match '/logout' => 'users#logout', via: [:get]

    match '/users' => 'admins#showUsers', via: [:get]
    match '/update' => 'admins#updateUsers', via: [:post]
    match '/edit/:username' => 'admins#editUser', via: [:get, :post]

end
