class Writer
  # Write an Array with data to a csv file
  def self.write_csv(file_name, all_data)
    puts 'Write data to the csv file'
    File.open(file_name, 'w') do |csv|
      csv << "Name;Category;Price;Availability;Url \n" # Write a column name
      all_data.each do |hash|
        csv << "#{hash[:name]};#{hash[:category]};#{hash[:price]};#{hash[:availability]};#{hash[:link]} \n"
      end
    end
  end
end
