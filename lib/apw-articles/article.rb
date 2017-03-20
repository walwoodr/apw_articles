class APWArticles::APWArticles
  attr_accessor :title, :author, :blurb, :url, :categories
  @@all = []

  def initialize(attribute_hash)
    self.categories = []
    attribute_hash.each do |key, value|
      if key == :categories
        values.each do |category|
          self.categories << APWArticles::Category.find_or_create_by_url(category)
          # NOTE: this depends on find_or_create_by_url returning an object
          # NOTE: this is a many:many relationship--may cause problems
        end
      else
        self.send(("#{key}="), value)
      end
  end

  def self.new_from_url(url)
    
  end

  def self.new_from_list(list_url)
    # call scraper for list and then initalize from hash
  end

  def self.all
    @@all
  end

end
