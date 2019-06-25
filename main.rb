require 'nokogiri'
require 'open-uri'
require 'csv'

class Scrape
  arr = []
  doc = Nokogiri::HTML(open('https://www.otomoto.pl/osobowe/audi/a6/'))
  doc.css('div.container-fluid.container-fluid-sm div.row ul.om-pager.rel')
      .search('span.page').each do |page|
    arr.push(page.text)
  end
  puts number_of_pages = arr.last.to_i

  CSV.open('file.csv', 'wb') do |csv|
    pages = 1..3
    pages.each do |current_page|
      doc = Nokogiri::HTML(open('https://www.otomoto.pl/osobowe/audi/a6/?page=' + current_page.to_s))
      product_tile = doc.css('div.offer-item__content')
      product_tile.each do |product|
        item_year = product.css('[data-code=year]')
                             .text.gsub(/ +/, ' ').gsub(/\n/, '').strip
        if item_year == ''
          next
        end
        item_mileage = product.css('[data-code=mileage]')
                                .text.gsub(/ +/, ' ').gsub(/\n/, '').strip
        if item_mileage == ''
          next
        end
        item_engine_capacity = product.css('[data-code=engine_capacity]')
                                        .text.gsub(/ +/, ' ').gsub(/\n/, '').strip
        if item_engine_capacity == ''
          next
        end
        item_fuel_type = product.css('[data-code=fuel_type]')
                                  .text.gsub(/ +/, ' ').gsub(/\n/, '').strip
        if item_fuel_type == ''
          next
        end
        item_price = product.css('div.offer-price span.offer-price__number')
                              .text.gsub(/ +/, ' ').gsub(/\n/, '').strip
        if item_price == ''
          next
        end
        csv << [item_year, item_mileage, item_engine_capacity, item_fuel_type, item_price]
      end
    end
  end
end