Rails.application.routes.draw do

  get 'user/show'

  get 'point_controller/show'

  root to: "welcome#index"

  require 'sidekiq/web'
  mount Sidekiq::Web => '/sidekiq'

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

  resources :point_alarms, only: [:create] do
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
    # 3D机房
    resources :three_dimensionals, only: [:index]
    
    resources :points, only: [] do
      collection do
        post :get_value_by_names
      end
      member do
        post :history_values
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
        get :count
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
        get :results
        get :import
        get :get_points
      end
    end

    resources :sub_systems, only:[] do
      resources :point_alarms, only: [:index]
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
    resources :rooms do # 机房管理
      member do 
        get :refresh
      end
      resources :devices, shallow: true do
        resources :points
      end
    end
    resources :reports
    resources :areas # 区域管理
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
      post :update_device
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
      get :points
    end
    resources :point_alarms, only: [:index]
  end

  resources :sms_tokens, only: [:create]

  namespace 'v2' do
    resources :rooms, only: [] do
      member do
        get :pue
      end
      resources :devices, only: [:show]
    end
    resources :point_alarms, only: [] do
      collection do
        get :count
      end
    end
  end
  resources :point_alarms, only: [:show]

end
