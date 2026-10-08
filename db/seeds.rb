# WAN NOW テスト用ユーザー
User.find_or_create_by!(email_address: "sample@example.com") do |user|
  user.name = "サンプルユーザー"
  user.password = "password"
  user.password_confirmation = "password"
end

puts "seedデータの作成が完了しました"