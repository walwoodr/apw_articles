require 'nokogiri'
require 'open-uri'
require 'pry'

class APWArticles::Scraper

  def self.scrape_list(url, category)

  end # I want this to return a hash of articles in a given category

  def self.scrape_article(url)

  end # I want this to return a hash of article information given an article URL

  private

  def self.scrape_categories(url)

  end # I want this to return a hash of categories on articles on a generic list

end


# i=1
# doc = {}
# until i == 13 # the actual list goes up to 12 pages
#   doc["Page #{i}"] =  Nokogiri::HTML(open("https://apracticalwedding.com/category/marriage-essays/page/#{i}/?listas=list"))
#   i+=1
# end
