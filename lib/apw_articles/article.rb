class APWArticles::Article
  attr_accessor :title, :author, :blurb, :url, :categories
  @@all = []

  def initialize(attribute_hash)
    self.categories = []
    self.set_values_from_hash(attribute_hash)
    @@all << self
  end

  def self.new_from_url(url)
    self.new(APWArticles::Scraper.scrape_article(url))
  end

  def set_values_from_hash(attribute_hash)
    attribute_hash.each do |key, value|
      if key == :categories
        value.each do |category|
          c = category if category.class == APWArticles::Category
          c = APWArticles::Category.find_or_create_by_url(category) if category.class == String
          # unless the category is already there
          self.categories << c unless self.categories.include?(c)
          c.articles << self
        end # value do end
      else
        self.send(("#{key}="), value)
      end # if category end
    end # for each in hash do end
  end

  def self.expand_from_url(url)
    attribute_hash = APWArticles::Scraper.scrape_article(url)
    self.find_by_title(attribute_hash[:title]).tap {|article| article.set_values_from_hash(attribute_hash)}
  end

  def self.new_from_list(attributes_array)
    attributes_array.each do |attributes_hash|
      self.new(attributes_hash)
    end # attributes_hash do end
  end # def end

  def self.all
    @@all
  end

  def self.find_by_title(title)
    self.all.find {|article| article.title == title}
  end

end
