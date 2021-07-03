Rails.application.routes.draw do

  root to: "public/homes#top"
  get '/about' => "public/homes#about"

  delete 'cart_items/remove_all' => "public/cart_items#remove_all"

  post 'orders/confirm' => "public/orders#confirm"
  get 'orders/thanks' => "public/orders#thanks"

  get 'customers/confirm' => "public/customers#confirm"
  patch 'customers/withdraw' => "public/customers#widhdraw"

  scope module: :public do
    resources :addresses, except: [:new, :show]
    resources :orders, except: [:destroy, :update, :edit]
    resources :cart_items, only: [:index, :update, :destroy, :create]
    resource :customers, only: [:show, :edit, :update]
    resources :items, only: [:index, :show]
  end

  devise_for :customers, :controllers => {
    :sessions => 'public/sessions',
    :registrations => 'public/registrations'
  }

  devise_for :admin, :controllers => {
    :sessions => 'admin/sessions'
  }

  get '/admin' => "admin/homes#top"
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  get '/search' => "public/items#search", as: 'search'

  namespace :admin do
    resources :items, except: [:destroy]
    resources :genres, except: [:show, :destroy, :new]
    resources :customers, except: [:create, :destroy, :new]
    resources :orders, only: [:show, :update]
    resources :order_items, only: [:update]
  end

end
