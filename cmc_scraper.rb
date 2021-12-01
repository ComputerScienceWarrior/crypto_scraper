require 'nokogiri'
require 'httparty'
require 'byebug'
require 'open-uri'

def scrape
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
	
	selection = gets.to_i - 1

	currency_url = 'https://coinmarketcap.com' +  rows[selection]

	doc = Nokogiri::HTML(URI.open(currency_url))


	coin_price = doc.css('.priceValue').children[0].children[0]
	puts coin_price
	sleep(2)
	puts "Would you Like to look at another coin's price? (y/n)"
	choice = gets.chomp

	if choice == 'y'
		puts "Okay, here we go!"
		scrape
	elsif choice == 'n'
		puts "Okay, goodbye!"
	else
		puts "Invalid input"
	end
end
