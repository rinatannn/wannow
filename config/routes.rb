Rails.application.routes.draw do
# グループ一覧・詳細・参加・退会
resources :groups, only: [ :index, :show ] do
  resource :group_membership, only: [ :create, :destroy ]
end

  # ドッグラン一覧・詳細
  resources :dog_runs, only: [ :index, :show ]
  resource :session
  resources :passwords, param: :token

  # チェックイン・チェックアウト
resources :check_ins, only: [ :create, :destroy ]

 # ユーザー新規登録
 resources :users, only: [ :new, :create, :show, :edit, :update, :destroy ]

 # 犬プロフィール
 resources :dogs, only: [ :new, :create, :show, :edit, :update, :destroy ]

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
