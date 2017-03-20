require 'nokogiri'
require 'open-uri'
require 'pry'
require_relative '../apw-articles.rb'

class APWArticles::Scraper

  def self.scrape_list(url, category)
      # URL example: https://apracticalwedding.com/category/marriage-essays/kids-no-kids/page/2/?listas=list
  end # I want this to return a hash of articles in a given category

  def self.scrape_article(url)

  end # I want this to return a hash of article information given an article URL

  private

  def self.scrape_categories
    doc = Nokogiri::HTML(open("https://apracticalwedding.com/category/marriage-essays/?listas=list")).css(".type-post")
    link_attributes = []
    doc.each { |link| link_attributes << link.attribute("class").value }
    # at this point link_attributes is an array with long strings of link attributes separated by spaces.
    link_attributes.each do |attributes_list|
      # class attributes that are categories are in the format "category-advice", so split using the preface
      attributes_array = attributes_list.split(/ category-/)
      # all non-category class attributes are at the beginning, so we can remove just the first item in the array to return categories
      attributes_array.slice!(0)
      # with each category class attribute, create a category object
      attributes_array.each do |category|
        # create only unique categories, and only include the first attribute (some have "tag-something-else" at the very end)
        APWArticles::Category.find_or_create_by_name(category.split[0])
      end # attributes_array do end
    end # link_attributes do end
    APWArticles::Category.all
  end # self.scrape_categories end

end

APWArticles::Scraper.scrape_categories
