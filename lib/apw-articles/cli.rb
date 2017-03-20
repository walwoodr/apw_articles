class APWArticles::CLI

  def run
    # first list categories to choose from
    # then list articles in the category 10 at a time
    # then display article information
    # allow user to go back to category list for any category in article
    # or go back to list of categories.
  end # shell of functionality

  def list_categories
    puts "------------ A Practical Wedding - Marriage Essays ------------"
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
    self.list_articles_in_category_by_page(APWArticles::Category.all[input.to_i-1], 1)
  end # list the categories available

  def list_articles_in_category_by_page(category, page = 1)
    # from page, generate an array of indexes, page 1 = 0-9, page 2 =  10-19, page 3 = 20-29 etc
    articles_to_display = Array (((page*10)-10)..((page*10)-1))
    puts "------------ Articles in #{category.name} ------------"
    articles_list = APWArticles::Scraper.scrape_list(category.url) # this returns articles_list which consists of the title and URL of each article
    # for each item in the articles_to_display array, print the article at that index, and the article's title.
    articles_to_display.each do |article_num|
      puts "#{article_num+1}. #{articles_list[article_num][:title]}"
    end
    # ask for input
    puts "Type the article number to view more information about the article. \n Type 'next' to view the next page of articles."
    input = gets.strip
    # validate input.
    until /(?i)next/ === input || input.to_i == articles_to_display[0] || input.to_i == articles_to_display[-1]
      "Please type a number between #{articles_to_display[0]} and #{articles_to_display[-1]} or type 'next'."
      input = gets.strip
    end
    # if the input is next,
    if /(?i)next/ === input
      # iterates var page up one and then calls this method again.
      page += 1
      list_articles_in_category_by_page(category, page)
    else # if the input is a number in the range.
      self.article_information(articles_list[article_num][:url])
      # call the article_information method using the # to reference the article URL to scrape.
      # NOTE : does the category object have the article information at this point?
    end
  end

  def article_information(article_url)
    article = APWArticles::APWArticle.new_from_url(article_url)
    puts "Title: #{article.title}"
    puts "Author: #{article.author}"
    puts "Blurb: #{article.blurb}"
    puts "URL: #{article_url}"
    article_categories = []
    article.categories.each do |category| # category is an object, and I want its name
      article_categories << category.name
    end
    article_categories.join(", ")
    puts "Categories: #{article_categories}."
    # display article information
    # offer to return to the article list page for any category that this article has
    # offer to return to category list page
  end # list article information

end
