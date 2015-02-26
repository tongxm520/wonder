Wonder::Application.routes.draw do
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

  # You can have the root of your site routed with "root"
  # just remember to delete public/index.html.
   
  match "users/confirm" => "users#confirm"
  match "/users/reactivate" => "users#reactivate"
  match "/welcome/index" => "welcome#index"
  
  resources :users do
    resources :posts do
      member do
        post 'delete'
        post 'del'
        get 'display'
      end
      
      collection do 
        get 'all'
      end
    end
    
		 member do
		   get 'activate'
		   get 'profile'
		   get 'account'
		   get 'logo'
		   post 'upload_logo'
		 end
  end
  
  resources :comments do
    resources :replies
  end
  
  controller :welcome do
    get 'register' => :register
    get 'login' => :login
    post 'login' => :create
    get 'logout' => :destroy
  end
    								
  post '/users/ajax_validate' => "users#ajax_validate"
  post '/users/test_ajax' => "users#test_ajax"
  post '/posts/upload'   =>"posts#upload"
  
  get '/friend/manage' => "friend#manage"
  get '/friend/search' => "friend#search"
  get '/friend/know' => "friend#know"
  get '/friend/invite' => "friend#invite"
  post '/friend/add_friend' =>"friend#add_friend"
  post '/friend/delete_friend' =>"friend#delete_friend"
  post '/friend/decide' =>"friend#decide"
  post '/friend/change_group' =>"friend#change_group"
  post '/friend/create_group' =>"friend#create_group"
  post '/friend/find' =>"friend#find"
  
  
  get "/welcome/search" => "welcome#search"
  get "/welcome/select" => "welcome#select"
  get "/welcome/show" => "welcome#show"
  post "/welcome/query" => "welcome#query"
  get "/welcome/locate" => "welcome#locate"
  
  namespace :api do
    get ':version/users' => 'users#index'
    post ':version/users' => 'users#create'
    get ':version/users/:user_id' => 'users#show'
    put ':version/users/:user_id' => 'users#update'
    delete ':version/users/:user_id' => 'users#destroy'
  end
  
  root :to => "welcome#login"

  get ':nick_name', to: 'friend#profile', as: :friend
  
  
  # See how all your routes lay out with "rake routes"

  # This is a legacy wild controller route that's not recommended for RESTful applications.
  # Note: This route will make all actions in every controller accessible via GET requests.
  # match ':controller(/:action(/:id(.:format)))'
end
