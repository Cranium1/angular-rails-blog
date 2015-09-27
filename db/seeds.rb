# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

require_relative "../lib/parsewordpress.rb"

user = User.find_or_create_by(name: 'Cranium') do | user |
  user.password = 'Johansson'
end

posts = WordpressParser.parse_file("oldsite.html").parse_articles

user.posts.create(posts)