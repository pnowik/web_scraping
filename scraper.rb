require 'nokogiri'
require 'open-uri'
require 'csv'

class Scraper
  @number_of_pages = 0
  def scrape
    read_number_of_pages
    read_pages_info
  end

  def read_number_of_pages
    arr = []
    doc = Nokogiri::HTML(open('https://www.otomoto.pl/osobowe/audi/a6/'))
    doc.css('div.container-fluid.container-fluid-sm div.row ul.om-pager.rel')
        .search('span.page').each do |page|
      arr.push(page.text)
    end
    @number_of_pages = arr.last.to_i
  end

  def read_pages_info
    CSV.open('file.csv', 'wb') do |csv|
      pages = 1..@number_of_pages
      pages.each do |current_page|
        doc = Nokogiri::HTML(open('https://www.otomoto.pl/osobowe/audi/a6/?page=' + current_page.to_s))
        product_tile = doc.css('div.offer-item__content')
        product_tile.each do |product|
          hash = item_info product
          csv << [hash['item_year'], hash['item_mileage'], hash['item_engine_capacity'], hash['item_fuel_type'], hash['item_price']]
        end
      end
    end
  end

  def item_info(num) {
    "item_year" => read_year(num),
    "item_mileage" => read_mileage(num),
    "item_engine_capacity" => read_engine_capacity(num),
    "item_fuel_type" => read_fuel_type(num),
    "item_price" => read_price(num)
    }
  end

  def read_year num
    num.css('[data-code=year]')
                     .text.gsub(/ +/, ' ').gsub(/\n/, '').strip
  end

  def read_mileage num
    num.css('[data-code=mileage]')
                        .text.gsub(/ +/, ' ').gsub(/\n/, '').strip
  end

  def read_engine_capacity num
    num.css('[data-code=engine_capacity]')
                                .text.gsub(/ +/, ' ').gsub(/\n/, '').strip
  end

  def read_fuel_type num
    num.css('[data-code=fuel_type]')
                          .text.gsub(/ +/, ' ').gsub(/\n/, '').strip
  end

  def read_price num
    num.css('div.offer-price span.offer-price__number')
                      .text.gsub(/ +/, ' ').gsub(/\n/, '').strip
  end

end
# scraper = Scraper.new
# scraper.scrape