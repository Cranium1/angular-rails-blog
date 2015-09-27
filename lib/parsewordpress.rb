require 'nokogiri'

class WordpressParser
	attr_reader :doc

	def initialize(input)
		@doc = Nokogiri::HTML(input)
	end

	def self.parse_file(filename)
		path = Rails.root.join('lib', 'assets', filename)
		file = File.open(path)
		self.new(file)
	end

	def parse_articles
		articles = @doc.xpath("//article")
		a = articles.collect do |article|
			post = {}
			post[:title] = article.xpath("header//h2//a").inner_html
			post[:html] = article.css(".entry-content").inner_html
			created = DateTime.parse(article.css(".entry-date").inner_html)
			updated = DateTime.parse(article.css(".updated").inner_html)
			post[:created_at] = created
			post[:updated_at] = updated
			post
		end
	end
end