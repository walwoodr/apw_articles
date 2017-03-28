class APWArticles::CLI

  def run
    APWArticles::Category.defaults
    self.list_categories
  end # basic functionality

  # Lists categories by iterating over APWARrticles::Category.all and requests input to view article list based on category
  def list_categories
    puts "------------ A Practical Wedding - Marriage Essays ------------\n".colorize(:cyan)
    puts "CATEGORIES:"
    APWArticles::Category.all.each_with_index do |category, index|
      print "#{index+1}.\t".colorize(:cyan)
      puts "#{category.name}"
    end # do loop end
    puts "\n\nPlease choose a category by number".colorize(:blue)
    input = gets.strip
    until input.to_i > 0 && input.to_i <= APWArticles::Category.all.size
      puts "Please type a number between 1 and #{APWArticles::Category.all.size}.".colorize(:blue)
      input = gets.strip
    end # until end
    self.list_articles_in_category_by_page(APWArticles::Category.all[input.to_i-1], 1)
  end # list_categories def end

  # Based on a category and a page number, this method creates an array of indexes of articles to list, then calls the scraper to scrape the category page to generate article objects for that category. The method then iterates over the array of articles to list, printing the article number and name for the article at that index in the category object's articles array.
  # Method then asks user to choose an article number to display.
  def list_articles_in_category_by_page(category, page = 1)
    articles_to_display = Array (((page*10)-10)..((page*10)-1)) # page 1 = 0-9, page 2 = 10-19
    puts "\n\n------------ Articles in #{category.name} ------------".colorize(:cyan)
    APWArticles::Article.new_from_list(APWArticles::Scraper.scrape_list(category, page)) unless page.between?(2,5) || page.between?(7,12)
    articles_to_display.each do |article_num|
      print "#{article_num+1}.\t".colorize(:cyan) unless
      category.articles[article_num] == nil
      puts "#{category.articles[article_num].title}" unless
      category.articles[article_num] == nil
    end # do end
    # NOTE: I might like to split out the input logic here.
    puts "\n\nType the article number to view more information about the article. \nOr type 'next' to view the next page of articles.".colorize(:blue)
    input = gets.strip
    until /(?i)next/ === input || ( input.to_i >= (articles_to_display[0]+1) && input.to_i <= (articles_to_display[-1]+1) )
      puts "Please type a number between #{articles_to_display[0]+1} and #{articles_to_display[-1]+1} or type 'next'.".colorize(:blue)
      input = gets.strip
    end # until end
    if /(?i)next/ === input
      page += 1
      list_articles_in_category_by_page(category, page)
    else
      self.article_information(category.articles[input.to_i-1].url)
    end # if end
  end # list_articles_in_category_by_page def end

  # This method creates a new Article object from the URL passed to the method and assigns it a local variable. The method then calls instance methods for each of the object's variables (title, author, blurb, url and categories). Then it requests input to view more information or exit.
  def article_information(article_url)
    article = APWArticles::Article.expand_from_url(article_url)
    print "\n\n------------ #{article.title} ------------".colorize(:cyan)
    print "\n\nAuthor:\t\t".colorize(:cyan)
    puts "#{article.author}"
    print "\nURL:\t\t".colorize(:cyan)
    puts "#{article_url}"
    article_categories = article.categories.collect do |category| # category is an object, and I want its name
      category.name
    end # do end
    print "\nCategories:\t".colorize(:cyan)
    puts "#{article_categories.join(", ")}."
    print "\n\t\t\t------- Blurb -------\n\n".colorize(:cyan)
    puts "\"#{article.blurb}...\""
    puts "\n\nType 'list' to return to the category list page. To exit, type 'exit'".colorize(:blue)
    input = gets.strip
    # validating input
    until /(?i)exit/ === input || /(?i)list/ === input
      puts "Please type 'list' or 'exit'.".colorize(:blue)
      input = gets.strip
    end # until end
    if /(?i)exit/ === input
      abort("Thank you.")
    elsif /(?i)list/ === input
      self.list_categories
    end # if end
  end # def article_information end

end # class end
