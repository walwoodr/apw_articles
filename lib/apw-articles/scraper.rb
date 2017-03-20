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
    link_classes = []
    doc.each { |link| link_classes << link.attribute("class").value }
    link_attributes.each do |attributes_list|
      attributes_array = attributes_list.split(/ category-/).slice!(0)
      attributes_array.each do |category|
        
      end
    end
  end # I want this to return an array of categories on articles on a generic list

end

APWArticles::Scraper.scrape_categories
