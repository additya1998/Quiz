Rails.application.routes.draw do
 
    # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
    match '/register' => 'users#register', via: [:get, :post]
    match '/login' => 'users#login', via: [:get, :post]
    match '/logout' => 'users#logout', via: [:get]
    
    match '/profile/:username' => 'users#profile', via: [:get]
    match '/profile' => 'users#profile', via: [:get]
    match '/dashboard' => 'users#index', via: [:get]
    
    match '/play' => 'games#play', via: [:post]
    match '/showQuestion/:category/:subCategory/:question' => 'games#showQuestion', via: [:get]
    match '/submit/:category/:subCategory/:question' => 'games#submit', via: [:post]

    match '/admin/showUsers' => 'admins#showUsers', via: [:get]
    match '/admin/updateUser' => 'admins#updateUser', via: [:post]
    match '/admin/editUser/:username' => 'admins#editUser', via: [:get, :post]
    match '/admin/registerUser' => 'admins#registerUser', via: [:get, :post]
   
    match '/admin/showAdmins' => 'admins#showAdmins', via: [:get]
    match '/admin/registerAdmin' => 'admins#registerAdmin', via: [:get, :post]


end