require 'nokogiri'
require 'httparty'
require 'byebug'
require 'open-uri'


url = 'https://coinmarketcap.com/'
doc = Nokogiri::HTML(URI.open(url))

coin_table = doc.css('.cmc-table tbody')
coin_rows = coin_table.children
rows = []
puts "Welcome! Please Select a Currency by it's corresponding number. (ex: '1' for 'Bitcoin')."
sleep(3)
coin_rows.each.with_index(1) do |coin, index|
	rows << coin.children[2].css('a')[0].attributes["href"].value
	puts "#{index}. #{coin.children[2].css('a')[0].attributes["href"].value}"
end


