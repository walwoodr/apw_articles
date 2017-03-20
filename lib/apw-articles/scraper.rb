require 'nokogiri'
require 'open-uri'
require 'pry'
require_relative '../apw-articles.rb'

class APWArticles::Scraper

  def self.scrape_list(category)
    # there are multiple pages of articles in each category, so we iterate up in the page count using variable i
    i = 1
    # create an empty articles_list array to hold article hashes
    articles_list = []
    # maxing out at 3 pages of articles (this is a practical limit, as there don't appear to be more than that in a given category)
    until i == 4
      # extract the page elements with class ".type-post" and iterate over them
      Nokogiri::HTML(open("https://apracticalwedding.com/category/marriage-essays/#{category}/page/#{i}/?listas=list")).css(".type-post").each do |post|
        # create an article hash and add to it a title and url
        article = {}
        article[:title] = post.css("h2").text
        article[:url] = post.css("a").attribute("href").value
        # add the article hash to the articles_list array
        articles_list << article
      end
      # iterate up
      i += 1
    end # until loop end
    # return articles_list array
    articles_list
    # NOTE: display title, scrape article using URL
  end

  def self.scrape_article(url)
    article = {}
    # NOTE: URL example: https://apracticalwedding.com/reclaiming-wife-new-mom-version/
    doc = Nokogiri::HTML(open(url))
    article[:title] = doc.css("h1 .title").text
    article[:author] = doc.css("h2 .author-list").text
    article[:blurb] = doc.css(".entry p")[0].text[0,200]
    categories = []
    doc.css(".categories a").each do |link|
      categories << link.attribute("href").value.split("/")[-1]
    end
    article[:categories] = categories
    article[:url] = url
    article
  end # NOTE: I want this to return article information given an article URL in the format "title, blurb, url, categories, author(optional)"

  # NOTE: private ???

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
      # NOTE: should this not be in here? It should probably be in the category class...
      attributes_array.each do |category|
        # create only unique categories, and only include the first attribute (some have "tag-something-else" at the very end)
        APWArticles::Category.find_or_create_by_url(category.split[0])
      end # attributes_array do end
    end # link_attributes do end
    APWArticles::Category.all
  end # self.scrape_categories end

end

APWArticles::Scraper.scrape_list("kids-no-kids")
