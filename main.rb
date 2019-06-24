require 'nokogiri'
require 'open-uri'
require 'csv'
require 'pry'

def scraper


  doc = Nokogiri::HTML(open('https://www.otomoto.pl/osobowe/audi/a6/'))
  product_tile = doc.css("div.offer-item__content")

  CSV.open("file.csv", "wb") do |csv|
    product_tile.each do |product|

      product.css("li.offer-item__params-item").search("span").each do |feature|
        puts feature.text
        csv << feature.text
      end
      puts item_price = product.css("div.offer-price span.offer-price__number").text.gsub(/ +/, " ").gsub(/\n/, "")
      csv << item_price
    end
  end

end

scraper