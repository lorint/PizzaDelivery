PizzaDelivery::Application.routes.draw do

  root to: "driver_shifts#index"
  get "driver_shifts/index"
  resources :driver_shifts

  resources :shifts do
    collection do
      post :update_individual
    end
  end

#  resources :drivers, only: [:new, :create]

  get 'drivers' => 'drivers#index', as: :drivers
  get 'drivers/:id' => 'drivers#show', as: :driver
  get 'drivers/new' => 'drivers#new', as: :new_driver
  post 'drivers' => 'drivers#create'
  get 'drivers/:id/edit' => 'drivers#edit', as: :edit_driver
  patch 'drivers/:id' => 'drivers#update'

  get 'availabilities' => 'availabilities#index', as: :availabilities
  get 'availabilities/:id' => 'availabilities#show', as: :availability


  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"
  # root 'welcome#index'

  # Example of regular route:
  #   get 'products/:id' => 'catalog#view'

  # Example of named route that can be invoked with purchase_url(id: product.id)
  #   get 'products/:id/purchase' => 'catalog#purchase', as: :purchase

  # Example resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Example resource route with options:
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

  # Example resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Example resource route with more complex sub-resources:
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', on: :collection
  #     end
  #   end

  # Example resource route with concerns:
  #   concern :toggleable do
  #     post 'toggle'
  #   end
  #   resources :posts, concerns: :toggleable
  #   resources :photos, concerns: :toggleable

  # Example resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end
end
