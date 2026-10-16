Rails.application.routes.draw do
  # グループ一覧・詳細・参加・退会
  resources :groups, only: [ :index, :show ] do
    resource :group_membership, only: [ :create, :destroy ]
  end

  # ドッグラン一覧・詳細
  resources :dog_runs, only: [ :index, :show ]

  # 来場予定一覧・登録・キャンセル
  resources :visit_plans, only: [ :index, :create, :destroy ]

  # チェックイン・チェックアウト
  resources :check_ins, only: [ :create, :destroy ]

  # ログイン・パスワード
  resource :session
  resources :passwords, param: :token

  # ユーザー新規登録・管理
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
  # get "manifest" => "rails/pwa/manifest#show"
  # get "service-worker" => "rails/pwa/service_worker#show"
end
