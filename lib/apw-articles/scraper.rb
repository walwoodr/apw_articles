require 'nokogiri'
require 'open-uri'
require 'pry'
require_relative '../apw-articles.rb'

class APWArticles::Scraper

  def self.scrape_list(category, page = 1)
    # there are multiple pages of articles in each category, so we iterate up in the page count using variable i
    # OKAY so   i is 1 AND until i > 1 if the array_of_indices includes 0 - 65 (page 1-5)
    #           i is 1 AND until i > 2 if page 6
    #           i is 2 AND until i > 2 if the array_of_indices includes 66 - 131
    #           i is 2 AND until i > 3 if page 13
    #           i is 3 AND until i > 3 if the array_of_indices includes 132 - 197
    # i = 1
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
        print "."

        APWArticles::Article.new({url: post.css("a").attribute("href").value, title: post.css("h1").text, categories: [category]})
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

APWArticles::CLI.new.run
