class APWArticles::APWArticles
  attr_accessor :name
  @@all = []

  def initialize(name, category)
    self.name = name
    # add to category if it exits, create and add if it doesn't. 
  end

  def self.all
    @@all
  end

end
