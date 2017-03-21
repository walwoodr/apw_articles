class APWArticles::Article
  attr_accessor :title, :author, :blurb, :url, :categories
  @@all = []

  def initialize(attribute_hash)
    self.categories = []
    attribute_hash.each do |key, value|
      if key == :categories
        value.each do |category|
          c = APWArticles::Category.find_or_create_by_url(category.url) if category.class == APWArticles::Category
          c = APWArticles::Category.find_or_create_by_url(category) if category.class == String
          self.categories << c
          c.articles << self
        end
      else
        self.send(("#{key}="), value)
      end
      @@all << self
    end
  end

  def self.new_from_url(url)
    self.new(APWArticles::Scraper.scrape_article(url))
  end

  def self.new_from_list(attributes_array)
    attributes_array.each do |attributes_hash|
      self.new(attributes_hash)
    end # attributes_hash do end
  end # def end

  def self.all
    @@all
  end

end
