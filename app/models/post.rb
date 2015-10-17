class Post < ActiveRecord::Base
	belongs_to :user

	def self.page(page=1)
		offset = (page-1)*5
		Post.all.order(created_at: :desc).limit(5).offset(offset)
	end

	def self.total_pages
		(Post.count / 5.to_f).ceil
	end
end