class APWArticles::Category
  attr_accessor :name, :articles, :url
  @@all = []

  def initialize(url)
    self.name = url.gsub(/-/, ' ').split.map(&:capitalize).join(' ')
    self.url = url
    self.class.all << self
    self.articles = []
  end

  def self.all
    @@all
  end

  def self.find_or_create_by_url(url)
    if self.all.detect{|category| category.url == url } == nil
      self.new(url)
    else
      self.all.detect{|category| category.url == url }
    end # NOTE verify this returns an object
  end

end
