class APWArticles::Category
  attr_accessor :name
  @@all = []

  def initialize(name = nil)
    self.name = name
    self.class.all << self
  end

  def self.all
    @@all
  end

end
