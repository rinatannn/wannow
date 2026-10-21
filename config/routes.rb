Rails.application.routes.draw do
namespace :admin do
  get "login", to: "sessions#new"
  post "login", to: "sessions#create"

  resources :groups
  resources :users, only: [ :index, :show ] do
    patch :suspend, on: :member
  end
end

  # 投稿機能
  resources :posts do
   resources :comments, only: [ :create, :destroy ]
  end

  # グループ一覧・詳細・新規作成・参加申請
  resources :groups, only: [ :index, :show, :new, :create ] do
  resource :group_membership, only: [ :create, :destroy ]


  resources :group_memberships, only: [] do
    patch :approve, on: :member
    patch :reject, on: :member
  end
end
  # ドッグラン一覧・詳細
  resources :dog_runs, only: [ :index, :show ]

  # 来場予定一覧・登録・キャンセル
  resources :visit_plans, only: [ :index, :create, :destroy ]

  # チェックイン・チェックアウト
  resources :check_ins, only: [ :create, :destroy ]

  # ログイン・パスワード
  resource :session
  post "guest_login", to: "sessions#guest", as: :guest_login
  resources :passwords, param: :token

  # ユーザー新規登録・管理
  resources :users, only: [ :index, :new, :create, :show, :edit, :update, :destroy ]

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
  # get "manifest" => "rails/pwa/manifest#show"
  # get "service-worker" => "rails/pwa/service_worker#show"
end
