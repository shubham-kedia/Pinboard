 Board::Application.routes.draw do

  # get "notice/index"

  # get "notice/create"

  # get "notice/delete"

  # get "notice/update"


  devise_for :users, :controllers => {:registrations => "users/registrations"}  , :path_names => {:sign_in => 'login' }
  match '/users/settings' => 'users#profile' ,:via => [:get] ,:as => :user_profile
  match '/users/update' => 'users#update' ,:via => [:put] ,:as => :user_update



  # The priority is based upon order of creation:
  # first created -> highest priority.

  # Sample of regular route:
  #   match 'products/:id' => 'catalog#view'
  # Keep in mind you can assign values other than :controller and :action

  # Sample of named route:
  #   match 'products/:id/purchase' => 'catalog#purchase', :as => :purchase
  # This route can be invoked with purchase_url(:id => product.id)

  # Sample resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Sample resource route with options:
  #   resources :products do
  #     member do
  #       get 'short'
  #       post 'toggle'
  #     end
  #
  #     collection do
  #       get 'sold'
  #     end
  #   end

  # Sample resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Sample resource route with more complex sub-resources
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', :on => :collection
  #     end
  #   end

  # Sample resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end
   resources :notices

   match '/notices/load_notices/' => 'notices#load_notices' ,:via => [:post]

   match '/notices/makeprivate/:id' => 'notices#make_private' ,:via => [:post]

   match '/notices/makepublic/:id' => 'notices#make_public' ,:via => [:post]
  # You can have the root of your site routed with "root"
  # just remember to delete public/index.html.
  # root :to => 'welcome#index'

    match '/notice/send_by_mail' => 'notices#sendemail' ,:via => [:post]

    root :to => "home#index"

  # See how all your routes lay out with "rake routes"

  # This is a legacy wild controller route that's not recommended for RESTful applications.
  # Note: This route will make all actions in every controller accessible via GET requests.
  # match ':controller(/:action(/:id))(.:format)'
end
