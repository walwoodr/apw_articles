require 'nokogiri'
require 'open-uri'
require 'pry'
require_relative '../apw-articles.rb'

class APWArticles::Scraper

  def self.scrape_list(category, page = 1)
    # # NOTE: probably I should only scrape for the # of articles I need for the given request / call - this is very laggy
    if page.between?(1,6)
      i = 1
    elsif page.between?(7,13)
      i = 2
    else
      i = 3
    end
    if page.between?(6,12)
      j = 2
    elsif page.between?(1,5)
      j = 1
    else
      j = 3
    end
    until i > j
      # extract the page elements with class ".type-post" and iterate over them
      Nokogiri::HTML(open("https://apracticalwedding.com/category/marriage-essays/#{category}/page/#{i}/?listas=list")).css(".type-post").each do |post|
        APWArticles::Article.new({url: post.css("a").attribute("href").value, title: post.css("h2").text, categories: [category]})
      end
      i += 1
    end # until loop end
    nil
  end

  def self.scrape_article(url)
    # create an empty hash about the article to populate using scraping of url in argument.
    article = {}
    # extract html from the url in argument
    doc = Nokogiri::HTML(open(url))
    # add title, url and author to the hash
    article[:title] = doc.css("h1").text
    article[:author] = doc.css(".staff-info h2").text
    article[:url] = url
    # add blurb to the hash, blurb is first 200 characters of the article
    article[:blurb] = doc.css(".entry p").text[0,400]
    # create an empty array of categories
    categories = []
    # for each category on the page, add the tail end of the URL to the categories array
    doc.css(".categories a").each do |link|
      categories << link.attribute("href").value.split("/")[-1]
    end
    # add the categories array to the hash using the key :categories
    article[:categories] = categories
    article
  end # returns hash of information on the article.

  # This method takes in a URL of a list page of essays at APW and creates an array of all link attributes on the essay links in the list. It then breaks apart the string of link attributes and returns an array of those attributes with the preface "category-",
  def self.scrape_categories(url = "https://apracticalwedding.com/category/marriage-essays/?listas=list")
    doc = Nokogiri::HTML(open(url)).css(".type-post")
    link_attributes = []
    categories = []
    doc.each { |link| link_attributes << link.attribute("class").value }
    link_attributes.each do |attributes_list|
      attributes_array = attributes_list.split(/ category-/)
      attributes_array.slice!(0)
      attributes_array.each do |category|
        categories << category.split[0]
      end # attributes_array do end
    end # link_attributes do end
    categories.uniq
  end # self.scrape_categories end

end

APWArticles::Category.create_from_url

APWArticles::CLI.new.run
