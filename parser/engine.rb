require 'pg'
require './db'
require './parser'
class Engine
  def initialize
    @threads = []
    @results = []
  end

  def threads(link, num)
    prepared_links = []
    @number_of_times = (link.size / num.to_f).ceil
    link.each_slice(@number_of_times) do |slice|
      prepared_links << slice
    end
    prepared_links
  end

  def write_to_db(result, db)
    db.exec "INSERT INTO Books (name, price, availability, created_at, updated_at)
VALUES('#{result[:name]}', #{result[:price]}, '#{result[:availability]}', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)"
  end

  def start(all_category_link, number_of_threads)
    data = threads(all_category_link, number_of_threads)
    data.each do |each_threads_links|
      i_times = 0
      # Add the thread for each category
      @threads << Thread.new do
        db = Db.new.connect
        each_threads_links.each do |url_category|
          puts "Parse category page: #{url_category}"
          # Get all product links on category page
          product_url = Parser.new.page_preparation(url_category).xpath("//div[@class='h4']/a/@href")
          i_times += 1
          i_page = 0
          last_page_num = product_url.size
          product_url.each do |page|
            result = Parser.new.parsing_product_page(page)
            @results << result
            write_to_db(result, db)
            puts "[#{i_page += 1}/#{last_page_num}][#{i_times}/#{@number_of_times}]"
          end
        end
      end
    end
    # Waiting for the end of each thread
    @threads.each(&:join)
    @results.flatten
  end
end
