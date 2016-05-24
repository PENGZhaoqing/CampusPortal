Rails.application.routes.draw do

  mount RailsAdmin::Engine => '/admin', as: 'rails_admin'


  use_doorkeeper do
    controllers :applications => 'oauth/applications'
  end

  get '/oauth/applications/:id/add_users' => 'oauth/applications#add_users', as: :cooperator_add_users
  get '/oauth/applications/:id/list_users' => 'oauth/applications#list_users', as: :cooperator_list_users
  # get '/oauth/applications/:application_id/users/:id/disassociate' => 'oauth/applications#disassociate',as: :cooperator_disassociate_user
  # get '/oauth/applications/:application_id/users/:id/associate' => 'oauth/applications#associate',as: :cooperator_associate_user


  get 'home/index'
  root 'home#gate'

  get '/me' => 'application#me'

  get 'password_resets/new'
  get 'password_resets/cooperator_edit'

  namespace :session do
    post 'user/login' => 'sessions#create_user'
    delete 'user/logout' => 'sessions#destroy_user'
    post 'admin/login' => 'sessions#create_admin'
    delete 'admin/logout' => 'sessions#destroy_admin'
    post 'cooperator/login' => 'sessions#create_cooperator'
    delete 'cooperator/logout' => 'sessions#destroy_cooperator'
  end


  resources :users, except: [:index] do

    resources :access, only: [:update] do
      member do
        get 'cooperator_edit'
        get 'admin_edit'
        get 'disassociate'
        get 'associate'
      end
    end

    member do
      get 'applications'
    end
  end

  resources :cooperators, except: [:index] do
    member do
      get 'applications'
    end
  end

  resources :account_activations, only: [:edit]
  resources :password_resets, only: [:new, :create, :edit, :update]


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
