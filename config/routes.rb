 Board::Application.routes.draw do
  get "user_settings/index"

  get "user_settings/show"

  get "user_settings/edit"

  get "user_settings/destroy"

  get "user_settings/update"

  devise_for :users, :controllers => {:registrations => "users/registrations", :sessions=>"users/sessions"}   #:path_names => {:sign_in => 'login' }

  match '/users/settings' => 'users#profile' ,:via => [:get] ,:as => :user_profile
  match '/users/update' => 'users#update' ,:via => [:put] ,:as => :user_update
  match "validate/:type" => "home#validate"

  resources :user_settings

  match '/notices/load_notices/' => 'notices#load_notices' ,:via => [:post,:get]

  match '/notices/:access_type/:id' => 'notices#change_access' ,:via => [:post]

  match '/notices/deleteImage/:id' => 'notices#deleteImage' ,:via => [:post]

  match '/users/board_settings' => 'users#board_settings' ,:via => [:get]
  resources :notices,:comments

  match '/notice/send_by_mail' => 'notices#sendemail' ,:via => [:post]
  match '/notice/search/:type/:keyword' => 'notices#search_by_keyword' ,:via => [:get]
  root :to => "home#index"
end
