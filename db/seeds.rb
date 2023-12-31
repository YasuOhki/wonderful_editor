# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

# テストデータの作成
num_users = 3
num_articles_by_user = 5

num_users.times do |i|
  user_name = "user#{i + 1}"

  tmp_user = User.create!(name: user_name.to_s, email: "#{user_name}@example.com", password: "test1234")

  num_articles_by_user.times do |j|
    if j.even?
      tmp_user.articles.create!(title: "#{user_name}のtitle_#{j + 1}", body: "#{user_name}のbody_#{j + 1}", status: "draft")
    else
      tmp_user.articles.create!(title: "#{user_name}のtitle_#{j + 1}", body: "#{user_name}のbody_#{j + 1}", status: "published")
    end
  end
end
