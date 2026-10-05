Rails.application.routes.draw do
  resource :session
  resources :passwords, param: :token

  # ユーザー新規登録
 resources :users, only: [:new, :create, :show, :edit, :update, :destroy]

  # マイページ
  get "mypage", to: "homes#mypage"

  # トップページ
  root "homes#top"

  # Aboutページ
  get "about" => "homes#about"

  # ヘルスチェック
  get "up" => "rails/health#show", as: :rails_health_check

  # PWA
  # get "manifest" => "rails/pwa#manifest", as: :pwa_manifest
  # get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker
end