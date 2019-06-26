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
          item_info product
          csv << [@item_year, @item_mileage, @item_engine_capacity, @item_fuel_type, @item_price]
        end
      end
    end
  end

  def item_info num
    read_year num
    read_mileage num
    read_engine_capacity num
    read_fuel_type num
    read_price num
  end

  def read_year num
    @item_year = num.css('[data-code=year]')
                     .text.gsub(/ +/, ' ').gsub(/\n/, '').strip
  end

  def read_mileage num
    @item_mileage = num.css('[data-code=mileage]')
                        .text.gsub(/ +/, ' ').gsub(/\n/, '').strip
  end

  def read_engine_capacity num
    @item_engine_capacity = num.css('[data-code=engine_capacity]')
                                .text.gsub(/ +/, ' ').gsub(/\n/, '').strip
  end

  def read_fuel_type num
    @item_fuel_type = num.css('[data-code=fuel_type]')
                          .text.gsub(/ +/, ' ').gsub(/\n/, '').strip
  end

  def read_price num
    @item_price = num.css('div.offer-price span.offer-price__number')
                      .text.gsub(/ +/, ' ').gsub(/\n/, '').strip
  end

end
scraper = Scraper.new
scraper.scrape