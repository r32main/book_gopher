class Parser

  # Download and prepare the page
  def page_preparation(page_link)
    page = Curl::Easy.perform(page_link).body_str
    Nokogiri::HTML(page)
  end

  # Get an Array of links to all category pages
  def all_url(main_url)
    last_page_num = page_preparation(main_url).xpath("//li[@class='disabled']/following-sibling::li")
                                              .first
                                              .text
                                              .to_i
    (0..last_page_num).map { |n| main_url.gsub(%r{(?<=/)\d(?=\?)}, n.to_s) }
  end

  def price(url)
    price = url.xpath("//div[@class='price_value']")
    price.empty? ? 0 : price.last.text.strip.to_f
  end

  def availability(url)
    availability = url.xpath("//div[@class='col-sm-7']/span")
    availability2 = url.xpath("//div[@class='col-sm-5']/span")
    if availability.text.empty?
      availability2.text.empty? ? 'Нет в наличии' : availability2.last.text.strip
    else
      availability.last.text.strip
    end
  end

  def category(url)
    category = url.xpath("//ol[@id='breadcrumbs']/li")
    category.empty? ? 'Нет категории' : category.last.text.strip
  end

  def name(url)
    url.xpath("//div[@class='bg_h1_small']/h1/text()").to_s.strip.gsub(/'/, '`')
  end

  def parsing_product_page(url)
    # Search data on the product page and writing it to an Array
    doc_product = page_preparation(url)
    { name: name(doc_product),
      category: category(doc_product),
      price: price(doc_product),
      availability: availability(doc_product),
      link: url.to_s }
  end
end
