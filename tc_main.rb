require 'test/unit'
require_relative 'main'

class TestScraper < Test::Unit::TestCase

  def setup
    @file = 'file.csv'
  end

  def test_csv_file
    assert_operator CSV.foreach(@file).count, :>=, 1, 'file is empty'
  end

  def test_csv_year
    CSV.foreach(@file) do |row|
      assert_match /\A\d\d\d\d\z/, row[0].gsub(/\s+/, ''), 'wrong format'
      assert_operator row[0].gsub(/\s+/, '').to_i, :>=, 1910,
                      'wrong year (the first Audi was created in 1910)'
      assert_operator row[0].gsub(/\s+/, '').to_i, :<=, Time.now.year,
                      "wrong year (greater than the current year #{Time.now.year})"
    end
  end

  def test_csv_mileage
    CSV.foreach(@file) do |row|
      assert_match /\A\d+[k][m]\z/i, row[1].gsub(/\s+/, ''), 'wrong format'
      assert_operator row[1].gsub(/\s+/, '').chomp('km').to_i, :>=, 1,
                      'at least 1 km'
    end
  end

  def test_csv_engine_capacity
    CSV.foreach(@file) do |row|
      assert_match /\A\d+[c][m][3]\z/i, row[2].gsub(/\s+/, ''), 'wrong format'
      assert_operator row[2].gsub(/\s+/, '').chomp('cm3').to_i, :>=, 1,
                      'at least 1000cm3'
    end
  end

  def test_csv_fuel_type
    CSV.foreach(@file) do |row|
      assert_match /\A\D+\z/i, row[3].gsub(/\s+/, ''), 'wrong format'
    end
  end

  def test_csv_price
    CSV.foreach(@file) do |row|
      assert_match /(\A\d+[P][L][N]\z)|(\A\d+[,]\d+[P][L][N]\z)|(\A\d+[E][U][R]\z)|(\A\d+[,]\d+[E][U][R]\z)/i, row[4].gsub(/\s+/, ''), 'wrong format'
      assert_operator row[4].gsub(/\s+/, '').chomp('PLN').to_i, :>=, 1,
                      'at least 1 PLN'
    end
  end

end