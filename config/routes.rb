Cms::Application.routes.draw do
  get "me", to: "homes#me"
  get "home", to: "homes#index", as: "home"
  get "categories", to: "article_categories#index", as: "categories"
  get "articles", to: "articles#index", as: "articles"
  get "page", to: "articles#page", as: "page"
  get "detail", to: "article_categories#detail", as: "category_detail"

  resources :users
  resources :sessions, only: [:new, :create, :destroy]
  resources :articles
  resources :article_categories

  match '/signin', to: 'sessions#new', via: :get
  match '/signout', to: 'sessions#destroy', via: :get
  match '/signup', to: 'users#new', via: :get
  match '/articles/(:id)', to: 'articles#update', via: :post
  match '/articles/(:id)', to: 'articles#destroy', via: :delete
  match '/categories/(:id)', to: 'article_categories#update', via: :post


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
  # root :to => 'welcome#index'

  # See how all your routes lay out with "rake routes"

  # This is a legacy wild controller route that's not recommended for RESTful applications.
  # Note: This route will make all actions in every controller accessible via GET requests.
  # match ':controller(/:action(/:id))(.:format)'
end
