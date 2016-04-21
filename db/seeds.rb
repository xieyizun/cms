# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)


100.times do |n|
  Article.create(title: '计算机'+(n).to_s, content: '计算机'+(n).to_s, category_id: 2, user_id: 1, created_on: Time.now)
  Article.create(title: 'web'+(n).to_s, content: 'web'+(n).to_s, category_id: 6, user_id: 1, created_on: Time.now)
end
