class APWArticles::CLI

  def run
    # first list categories to choose from
    # then list articles in the category 10 at a time
    # then display article information
    # allow user to go back to category list for any category in article
    # or go back to list of categories.
  end # shell of functionality

  def list_categories
    puts "------------ A Practical Wedding - Marriage Essays ------------\n"
    puts "CATEGORIES:"
    # populate the list using scrape_list
    APWArticles::Scraper.scrape_categories
    # display the list by iterating over APWARrticles::Category.all
    APWArticles::Category.all.each_with_index do |category, index|
      puts "#{index+1}.\t#{category.name}"
    end
    puts "\nPlease choose a category by number"
    # NOTE: also offer an exit option here?
    input = gets.strip
    # request new input until the input to integer is more than 0 (not a string) and less than the total number of categories
    until input.to_i > 0 && input.to_i <= APWArticles::Category.all.size
      puts "Please type a number between 1 and #{APWArticles::Category.all.size}."
      input = gets.strip
    end
    # once the input is acceptable, display article list based on number
    self.list_articles_in_category_by_page(APWArticles::Category.all[input.to_i-1], 1)
  end # list the categories available

  def list_articles_in_category_by_page(category, page = 1)
    # from page, generate an array of indexes, page 1 = 0-9, page 2 =  10-19, page 3 = 20-29 etc
    articles_to_display = Array (((page*10)-10)..((page*10)-1))
    puts "\n\n------------ Articles in #{category.name} ------------"
    articles_list = APWArticles::Scraper.scrape_list(category.url) # this returns articles_list which consists of the title and URL of each article
    # NOTE this is very laggy and should probably not take place here. perhaps create list_articles_in_category that calls this for subsequent pages like I was originally thinking?
    # for each item in the articles_to_display array, print the article at that index, and the article's title.
    articles_to_display.each do |article_num|
      puts "#{article_num+1}.\t#{articles_list[article_num][:title]}" unless articles_list[article_num] == nil
    end
    # ask for input
    puts "\n\nType the article number to view more information about the article. \nOr type 'next' to view the next page of articles."
    input = gets.strip
    # validate input.
    until /(?i)next/ === input || ( input.to_i >= (articles_to_display[0]+1) && input.to_i <= (articles_to_display[-1]+1) )
      "Please type a number between #{articles_to_display[0]} and #{articles_to_display[-1]} or type 'next'."
      input = gets.strip
    end
    # if the input is next,
    if /(?i)next/ === input
      # iterates var page up one and then calls this method again.
      page += 1
      list_articles_in_category_by_page(category, page)
    else # if the input is a number in the range.
      self.article_information(articles_list[input.to_i-1][:url])
      # call the article_information method using the # to reference the article URL to scrape.
      # NOTE : does the category object have the article information at this point?
    end
  end

  def article_information(article_url)
    # create a local variable for the article object
    article = APWArticles::APWArticle.new_from_url(article_url)
    # display article information
    puts "\nTitle: #{article.title}"
    puts "\nAuthor: #{article.author}"
    puts "\n\nBlurb: \"#{article.blurb}...\""
    puts "\nURL: #{article_url}"
    # create an article_categories array and join that array
    article_categories = []
    article.categories.each do |category| # category is an object, and I want its name
      article_categories << category.name
    end
    puts "\nCategories: #{article_categories.join(", ")}."
    puts "Type 'list' to return to the category list page. To exit, type 'exit'"
    input = gets.strip
    # validating input
    until /(?i)exit/ === input || /(?i)list/ === input
      puts "Please type 'list' or 'exit'."
      input = gets.strip
    end
    if /(?i)exit/ === input
      abort("Thank you.")
    elsif /(?i)list/ === input
      self.list_categories
    end
  end # list article information

end
