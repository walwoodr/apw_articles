class APWArticles::CLI

  def run
    APWArticles::Category.defaults
    self.list_categories
  end # basic functionality

  # Lists categories by iterating over APWARrticles::Category.all and requests input to view article list based on category
  def list_categories
    puts "------------ A Practical Wedding - Marriage Essays ------------\n"
    puts "CATEGORIES:"
    APWArticles::Category.all.each_with_index do |category, index|
      puts "#{index+1}.\t#{category.name}"
    end # do loop end
    puts "\nPlease choose a category by number"
    input = gets.strip
    until input.to_i > 0 && input.to_i <= APWArticles::Category.all.size
      puts "Please type a number between 1 and #{APWArticles::Category.all.size}."
      input = gets.strip
    end # until end
    self.list_articles_in_category_by_page(APWArticles::Category.all[input.to_i-1], 1)
  end # list_categories def end

  # Based on a category and a page number, this method creates an array of indexes of articles to list, then calls the scraper to scrape the category page to generate article objects for that category. The method then iterates over the array of articles to list, printing the article number and name for the article at that index in the category object's articles array.
  # Method then asks user to choose an article number to display.
  def list_articles_in_category_by_page(category, page = 1)
    articles_to_display = Array (((page*10)-10)..((page*10)-1)) # page 1 = 0-9, page 2 = 10-19
    puts "\n\n------------ Articles in #{category.name} ------------"
    APWArticles::Scraper.scrape_list(category.url, page) unless page.between?(2,5) || page.between?(7,12)
    # NOTE this is very laggy and perhaps shouldn't take place here.
    articles_to_display.each do |article_num|
      puts "#{article_num+1}.\t#{
      category.articles[article_num].title}" unless
      category.articles[article_num] == nil
    end # do end
    # NOTE: I might like to split out the input logic here.
    puts "\n\nType the article number to view more information about the article. \nOr type 'next' to view the next page of articles."
    input = gets.strip
    until /(?i)next/ === input || ( input.to_i >= (articles_to_display[0]+1) && input.to_i <= (articles_to_display[-1]+1) )
      "Please type a number between #{articles_to_display[0]} and #{articles_to_display[-1]} or type 'next'."
      input = gets.strip
    end # until end
    if /(?i)next/ === input
      page += 1
      list_articles_in_category_by_page(category, page)
    else
      self.article_information(
      category.articles[input.to_i-1].url)
    end # if end
  end # list_articles_in_category_by_page def end

  # This method creates a new Article object from the URL passed to the method and assigns it a local variable. The method then calls instance methods for each of the object's variables (title, author, blurb, url and categories). Then it requests input to view more information or exit.
  def article_information(article_url)
    article = APWArticles::Article.new_from_url(article_url)
    puts "\nTitle: #{article.title}"
    puts "\nAuthor: #{article.author}"
    puts "\n\nBlurb: \"#{article.blurb}...\""
    puts "\nURL: #{article_url}"
    article_categories = []
    article.categories.each do |category| # category is an object, and I want its name
      article_categories << category.name
    end # do end
    puts "\nCategories: #{article_categories.join(", ")}."
    puts "Type 'list' to return to the category list page. To exit, type 'exit'"
    input = gets.strip
    # validating input
    until /(?i)exit/ === input || /(?i)list/ === input
      puts "Please type 'list' or 'exit'."
      input = gets.strip
    end # until end
    if /(?i)exit/ === input
      abort("Thank you.")
    elsif /(?i)list/ === input
      self.list_categories
    end # if end
  end # def article_information end

end # class end
