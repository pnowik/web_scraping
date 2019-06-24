require 'nokogiri'
require 'open-uri'
require 'csv'
require 'pry'

def scraper

  arr = Array.new
  doc = Nokogiri::HTML(open('https://www.otomoto.pl/osobowe/audi/a6/'))
  doc.css("div.container-fluid.container-fluid-sm div.row ul.om-pager.rel").search("span.page").each do |page|
    arr.push(page.text)
  end
  pages = arr.last.to_i

  CSV.open("file.csv", "wb") do |csv|
    digits = 1..pages
    csv << ["Rok produkcji", "Przebieg", "Pojemność silnika", "Rodzaj paliwa", "Cena"]
    digits.each do |current_page|
      doc = Nokogiri::HTML(open('https://www.otomoto.pl/osobowe/audi/a6/?page=' + current_page.to_s))
      product_tile = doc.css("div.offer-item__content")

      product_tile.each do |product|
        arr = Array.new
        product.css("li.offer-item__params-item").search("span").each do |feature|
          arr.push(feature.text.strip)
        end

      item_price = product.css("div.offer-price span.offer-price__number").text.gsub(/ +/, " ").gsub(/\n/, "")
      arr.push(item_price)
      csv << [arr[0], arr[1], arr[2], arr[3], arr[4]]
      end
    end
  end

end

scraper