class APWArticles::Scraper

  # This class method defines variables i and j to determine what url number needs to be scraped based on the number of items on each page (at time of publicaion, 66 articles/page). The method then scrapes a url based on the category and URL number and uses that page's list of articles to creates a new article object per article link. Article objects include title, url and category. The method returns nil
  def self.scrape_list(category, page = 1)
    # binding.pry
    category.create_category_urls(page = 1).each do |url|
      Nokogiri::HTML(open(url)).css(".type-post").each do |post|
        # NOTE: should this be done in article creation
        APWArticles::Article.new({url: post.css("a").attribute("href").value, title: post.css("h2").text, categories: [category]})
      end # do post end
    end # do url end
    nil
  end # def end

  # This method takes an article URL, creates an article hash then populates that article hash using information scraped from the URL. The method then returns the article hash.
  def self.scrape_article(url)
    article = {}
    doc = Nokogiri::HTML(open(url))
    article[:title] = doc.css("h1").text
    article[:author] = doc.css(".staff-info h2").text
    article[:url] = url
    article[:blurb] = doc.css(".entry p").text[0,400]
    categories = []
    doc.css(".categories a").each do |link|
      categories << link.attribute("href").value.split("/")[-1]
    end # do end
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
