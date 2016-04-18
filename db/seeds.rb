# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)


100.times do |n|
  Article.create(title: (n+200).to_s, content: (n+200).to_s, category_id: 1, user_id: 1, created_on: Time.now)
end
