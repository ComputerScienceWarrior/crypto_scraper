require 'nokogiri'
require 'httparty'
require 'byebug'
require 'open-uri'

def scrape
	user_greeting
	rows = [] #rows will hold the 'href' value to append to coinmarketcap.com for level 2 scraping data
	scrape_data(rows) #get coinmarketcap.com current coin listing.

	selection = gets.to_i - 1 #get user's selection of coin

	currency_url = 'https://coinmarketcap.com' +  rows[selection]

	doc = Nokogiri::HTML(URI.open(currency_url))

	coin_name = doc.css('.nameHeader').children[1].children[0]
	coin_price = doc.css('.priceValue').children[0].children[0]
	coin_symbol = doc.css('.nameHeader').children[1].children[1].children[0]
	puts "The current price of #{coin_name} (#{coin_symbol}) is #{coin_price} per coin."

	sleep(2)

	choice = another_selection?

	if choice.downcase == 'y'
		scrape
	elsif choice.downcase == 'n'
		puts "Okay, goodbye!"
	else
		puts "Invalid input, make another selection."
		another_selection?
	end
end

def another_selection?
	puts "Would you like to make another selection? (y/n)"
	choice = gets.chomp
	return choice
end

def coin_or_number?
	puts "Would you like to search by coin, or choose a number in list?"
	sleep(2)
	puts "Enter 'number' or 'n', OR enter 'coin' or 'c'."
	input = gets.chomp
	if input == 'number' || input == 'n'

	elsif input == 'coin' || input == 'c'

	else
		puts "Invalid input, please make a proper selection based on instructions.."
		coin_or_number?
	end
end

def scrape_data(rows)
	url = 'https://coinmarketcap.com/'
	doc = Nokogiri::HTML(URI.open(url))
	coin_table = doc.css('.cmc-table tbody')
	coin_rows = coin_table.children

	coin_rows.each.with_index(1) do |coin, index|
		rows << coin.children[2].css('a')[0].attributes["href"].value
		if index.between?(1, 10)
			puts "#{index}. #{coin.children[2].css('a')[0].css('div p').children[0]}"
		elsif index.between?(11, 50)
			puts "#{index}. #{coin.children[2].css('a')[0].children[1].children[0]}"
		end
	end
end

def user_greeting
	puts "Welcome! Please Select a Currency by it's corresponding number. (ex: '1' for 'Bitcoin')."
	sleep(3)
end

scrape
