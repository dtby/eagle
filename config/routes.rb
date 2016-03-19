Rails.application.routes.draw do

  get 'user/show'

  get 'point_controller/show'

  root to: "welcome#index"

  #动力
  resources :power, only: [:index] do
    collection do
      get :ups
      get :distrib
      get :crac
      get :air_d
      get :temperature
      get :cabinet
      get :wind
    end
  end

  resources :point_alarms, only: [] do
    member do
      patch :checked, :unchecked
      post :checked, :unchecked
      get :modal
    end
    collection do
      patch :update_multiple
      post :update_multiple
    end
  end

  #能效
  resources :pem, only: [:index] do
    collection do
      get :aircondition
    end
  end

  resources :rooms, only: [:index, :show] do
    resources :points, only: [] do 
      collection do
        post :get_value_by_names
      end
    end

    resources :devices, only: [:index, :show] do  # 设备
      collection do
        post :search
      end
      member do
        get :refresh_data
        resources :points, only: [:index, :show]
      end
    end
    resources :point_alarms, only: [:index] do
      collection do
        post :count
      end
    end
    member do
      get :alert
      get :checked_alert
      get :video
      get :pic
      get :refersh_alert
    end
    #报表
    resources :reports, only: [:index] do
      collection do
        get :replace_chart
        get :get_points
      end
    end

    resources :sub_systems, only:[] do 
      collection do
        get :distrib
        get :ups
        get :column_head_cabinet
        get :ats
        get :battery
        get :diesel_engine
        get :temperature_humidity
        get :water_leakage
        get :air_d
        get :cabinet_temp_humidity
      end
    end
  end

  namespace :admin do
    root 'home#index'
    resources :users # 用户
    resources :patterns # 型号设置
    resources :admins # 管理用户
    resources :rooms # 机房管理
    resources :ftps, only: [:index, :create]
    resources :attachments do
      member do
        post :delete
        patch :delete
      end
    end
  end

  devise_for :admins, controllers: {
    sessions: 'admins/sessions',
    passwords: 'admins/passwords'
  }

  constraints(id: /\d+/) do
    resources :users, only: :show
  end

  resources :users, only: [] do
    collection do
      post :update_password
    end    
  end

  devise_for :users, controllers: {
    sessions: 'users/sessions',
    passwords: 'users/passwords'
  }

  resources :systems, only: [:index]

  resources :check_phone, only: [] do 
    collection do
      post :auth
      post :auth_admin
    end
  end

  resources :devices, only: [] do 
    member do
      resources :point_alarms, only: [:index]
    end
  end

  resources :sms_tokens, only: [:create]

  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"

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
