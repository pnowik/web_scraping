require 'test/unit'
require_relative 'scraper'

class TestScraper2 < Test::Unit::TestCase

  def setup
    @file = 'file.csv'
    @scraper = Scraper.new
  end

  def test_number_of_pages
    @scraper.read_number_of_pages
    assert_not_equal @scraper.read_number_of_pages, 0,
                     'number of pages is 0, error reading number of pages (method number_of_pages)'
  end

  def test_csv_file
    assert_operator CSV.foreach(@file).count, :>=, 1, 'file is empty'
  end

  def test_csv_year
    CSV.foreach(@file) do |row|
      assert_match /(\A\d\d\d\d\z)|(\A\z)/, row[0].gsub(/\s+/, ''), 'wrong format'
      if row[0].gsub(/\s+/, '') != ''
        assert_operator row[0].gsub(/\s+/, '').to_i, :>=, 1910,
                        'wrong year (the first Audi was created in 1910)'
        assert_operator row[0].gsub(/\s+/, '').to_i, :<=, Time.now.year,
                        "wrong year (greater than the current year #{Time.now.year})"
      end
    end
  end

  def test_csv_mileage
    CSV.foreach(@file) do |row|
      assert_match /(\A\d+[k][m]\z)|(\A\z)/i, row[1].gsub(/\s+/, ''), 'wrong format'
      if row[1].gsub(/\s+/, '') != ''
        assert_operator row[1].gsub(/\s+/, '').chomp('km').to_i, :>=, 1,
                        'at least 1 km'
      end
    end
  end

  def test_csv_engine_capacity
    CSV.foreach(@file) do |row|
      assert_match /(\A\d+[c][m][3]\z)|(\A\z)/i, row[2].gsub(/\s+/, ''), 'wrong format'
      if row[2].gsub(/\s+/, '') != ''
        assert_operator row[2].gsub(/\s+/, '').chomp('cm3').to_i, :>=, 1,
                        'at least 1000cm3'
      end
    end
  end

  def test_csv_fuel_type
    CSV.foreach(@file) do |row|
      assert_match /(\A\D+\z)|(\A\z)/i, row[3].gsub(/\s+/, ''), 'wrong format'
    end
  end

  def test_csv_price
    CSV.foreach(@file) do |row|
      assert_match /(\A\d+[P][L][N]\z)|(\A\d+[,]\d+[P][L][N]\z)|(\A\d+[E][U][R]\z)|(\A\d+[,]\d+[E][U][R]\z)|(\A\z)/i, row[4].gsub(/\s+/, ''), 'wrong format'
      if row[4].gsub(/\s+/, '') != ''
        assert_operator row[4].gsub(/\s+/, '').chomp('PLN').to_i, :>=, 1,
                        'at least 1 PLN'
      end
    end
  end

=begin
  def test_correct_format
    @scraper.read_number_of_pages
    pages = 1..@number_of_pages
    pages.each do |current_page|
      doc = Nokogiri::HTML(open('https://www.otomoto.pl/osobowe/audi/a6/?page=' + current_page.to_s))
      product_tile = doc.css('div.offer-item__content')
      product_tile.each do |product|
        @item_year = @scraper.read_year product
        @item_mileage = @scraper.read_mileage product
        @item_engine_capacity = @scraper.read_engine_capacity product
        @item_fuel_type = @scraper.read_fuel_type product
        @item_price = @scraper.read_price product
        test_read_year @item_year
        test_read_mileage @item_mileage
        test_read_engine_capacity @item_engine_capacity
        test_read_fuel_type @item_fuel_type
        test_read_price @item_price
      end
    end
  end

  def test_read_year item
    assert_match /(\A\d\d\d\d\z)|(\A\z)/, item.gsub(/\s+/, ''),
                 'wrong year format (error read_year)'
    if item.gsub(/\s+/, '') != ''
      assert_operator item.gsub(/\s+/, '').to_i, :>=, 1910,
                      'wrong year (the first Audi was created in 1910)'
      assert_operator item.gsub(/\s+/, '').to_i, :<=, Time.now.year,
                      "wrong year (greater than the current year #{Time.now.year})"
    end
  end

  def test_read_mileage item
    assert_match /(\A\d+[k][m]\z)|(\A\z)/i, item.gsub(/\s+/, ''),
                 'wrong mileage format (error read_mileage)'
    if item.gsub(/\s+/, '') != ''
      assert_operator item.gsub(/\s+/, '').chomp('km').to_i, :>=, 1,
                      'at least 1 km'
    end
  end

  def test_read_engine_capacity item
    assert_match /(\A\d+[c][m][3]\z)|(\A\z)/i, item.gsub(/\s+/, ''),
                 'wrong engine capacity format (error read_engine_capacity)'
    if item.gsub(/\s+/, '') != ''
      assert_operator item.gsub(/\s+/, '').chomp('cm3').to_i, :>=, 1,
                      'at least 1000cm3'
    end
  end

  def test_read_fuel_type item
    assert_match /(\A\D+\z)|(\A\z)/i, item.gsub(/\s+/, ''),
                 'wrong fuel type format (error read_fuel_type)'
  end

  def test_read_price item
    assert_match /(\A\d+[P][L][N]\z)|(\A\d+[,]\d+[P][L][N]\z)|(\A\d+[E][U][R]\z)|(\A\d+[,]\d+[E][U][R]\z)|(\A\z)/i, @item_price.gsub(/\s+/, ''),
                 'wrong price format (error read_price)'
    if item.gsub(/\s+/, '') != ''
      assert_operator item.gsub(/\s+/, '').chomp('PLN').to_i, :>=, 1,
                      'at least 1 PLN'
    end
  end
=end

end