# 管理者アカウントの初期登録
admin_email = ENV["ADMIN_EMAIL"]
admin_password = ENV["ADMIN_PASSWORD"]

if admin_email.present? && admin_password.present?
  User.find_or_create_by!(email_address: admin_email) do |user|
    user.name = "管理者"
    user.password = admin_password
    user.password_confirmation = admin_password
    user.admin = true
    user.is_active = true
  end
else
  puts "管理者の環境変数が未設定のため、作成をスキップしました"
end

# WAN NOW テスト用ユーザー
User.find_or_create_by!(email_address: "sample@example.com") do |user|
  user.name = "サンプルユーザー"
  user.password = "password"
  user.password_confirmation = "password"
end

# グループの初期データ
groups = [
  { name: "小型犬グループ", description: "小型犬の飼い主同士で交流するグループ" },
  { name: "中型犬グループ", description: "中型犬の飼い主同士で交流するグループ" },
  { name: "大型犬グループ", description: "大型犬の飼い主同士で交流するグループ" },
  { name: "パピー（子犬）グループ", description: "子犬の飼い主同士で交流するグループ" },
  { name: "シニア犬グループ", description: "シニア犬の飼い主同士で交流するグループ" }
]

groups.each do |group|
  Group.find_or_create_by!(name: group[:name]) do |record|
    record.description = group[:description]
  end
end

puts "seedデータの作成が完了しました"
