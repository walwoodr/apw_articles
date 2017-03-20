class APWArticles::Category
  attr_accessor :name, :articles
  @@all = []

  def initialize(name = nil)
    self.name = name
    self.class.all << self
    self.articles = []
  end

  def self.all
    @@all
  end

  def self.find_or_create_by_name(name)
    if self.all.detect{|category| category.name == name } == nil
      self.new(name)
    else

    end
  end

end
