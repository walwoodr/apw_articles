class APWArticles::Category
  attr_accessor :name, :articles, :url
  @@all = []
  CATEGORIES = ["divorce", "kids-no-kids", "sex", "career", "life", "marriage-essays", "money", "feminism", "essays", "the-hard-stuff", "reclaiming-wife", "advice", "genderfeminism", "friends-relations", "engagements-proposals", "happy-hour"]
  # NOTE: the CATEGORIES constant was gathered using the APWArticles::Scraper.scrape_categories method, however as the only way to scrape this information was iterating over 66 articles which is rather time-consuming in the CLI, I have elected to hard code the categories as default categories. New category objects will still be made when they're encountered in articles. 

  def self.defaults
    CATEGORIES.each {|url| self.new(url)}
  end

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
