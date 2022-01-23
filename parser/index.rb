require 'curb'
require 'nokogiri'
require 'csv'
require './parser'
require './writer'
require './engine'

# User data

main_link = 'https://bukva.ua/ua/catalog/browse/445/1?filter%5Bfilter_type%5D=exisit&sort=default&sort_dir=&filter_type=all&page=1&g_pp=2000'
all_category_link = Parser.new.all_url(main_link)
puts "Your category link: #{main_link}"

file_name = "result#{Time.now.to_a[3, 3].join}.csv"
puts "Your file name: #{file_name}"

number_of_threads = 5 # should be > 0

# Start parsing
t1 = Time.new
Writer.write_csv(file_name, Engine.new.start(all_category_link, number_of_threads))

# End parsing
puts "Parsing finished. Time: #{Time.now - t1}"
