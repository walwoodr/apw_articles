class APWArticles::APWArticles
  attr_accessor :title, :author, :blurb, :url, :categories
  @@all = []

  def initialize(title, blurb, url, categories, author = nil) #does this need to be an info hash? I don't think so -- I know what each article has. But author should probably be optional?
    self.title = title
    self.author = author unless author == nil
    self.blurb = "#{blurb}..."
    self.url = url
    self.categories = []
    categories.each do |category|
      self.categories << APWArticles::Category.find_or_create_by_url # this depends on find_or_create_by_url returning an object
      # can i actually do a many:many relationship?
    end
  end

  def self.new_from_url(url)
    # call scraper and then initialize from hash
  end

  def self.new_from_list(list_url)
    # call scraper for list and then initalize from hash
  end

  def self.all
    @@all
  end

end
