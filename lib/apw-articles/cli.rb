class APWArticles::CLI

  def run
    # first list categories to choose from
    # then list articles in the category 10 at a time
    # then display article information
    # allow user to go back to category list for any category in article
    # or go back to list of categories.
  end # shell of functionality

  def list_categories
    puts "------------A Practical Wedding - Marriage Essays------------"
    puts "CATEGORIES:"
    # populate the list using scrape_list
    APWArticles::Scraper.scrape_categories
    # display the list by iterating over APWARrticles::Category.all
    APWArticles::Category.all.each_with_index do |category, index|
      puts "#{index+1}. #{category.name}"
    end
    puts "Please choose a category by number"
    input = gets.strip
    # request new input until the input to integer is more than 0 (not a string) and less than the total number of categories
    until input.to_i > 0 && input.to_i < APWArticles::Category.all.size
      puts "Please type a number between 1 and #{APWArticles::Category.all.size}."
      input = gets.strip
    end
    # once the input is acceptable, display article list based on number
    self.list_articles_in_category_by_page(APWArticles::Category.all[input.to_i-1].url, 1)
  end # list the categories available

  def list_articles_in_category_by_page(category, page = 1)
    # from page, generate an array of indexes, page 1 = 0-9, page 2 =  10-19, page 3 = 20-29 etc
    articles_list = APWArticles::Scraper.scrape_list(category) # this returns articles_list which consists of the title and URL of each article
    articles_to_display = Array (((page*10)-10)..((page*10)-1)
    articles_to_display.each do |article_num|
      puts "#{article_num}. #{articles_list[article_num].title}"
    end
    # have them type "next" to display the next page, which iterates page up one and then calls this method again. 
  end

  def article_information
    # display article information by
  end # list article information

end
