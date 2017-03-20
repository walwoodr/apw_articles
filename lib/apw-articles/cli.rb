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
    APWArticles::Category.all.each_with_index do |category, index|
      puts "#{index+1}. #{category.name}"
    end
    puts "Please choose a category by number or title."
    input = gets.strip
    if input.to_i == 0
      # compare for words
      # display article based on word
    elsif input.to_i > 0
      # compare for numbers
      # display article based on number
    end
  end # list the categories available

  def list_articles_in_category
    # I'll probably want to do this only a few at a time
  end # list articles in a category

  def article_information
    # display article information by
  end # list article information

end
