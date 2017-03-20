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
    link_attributes.each do |attributes_list|
      attributes_array = attributes_list.split(/ category-/)
      attributes_array.slice!(0)
      attributes_array.each do |category|
        APWArticles::Category.find_or_create_by_name(category)
      end # attributes_array do end
    end # link_attributes do end
    APWArticles::Category.all
    binding.pry
  end # self.scrape_categories end

end

APWArticles::Scraper.scrape_categories
