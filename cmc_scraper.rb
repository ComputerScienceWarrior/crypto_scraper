require 'nokogiri'
require 'httparty'
require 'byebug'
require 'open-uri'

def scrape
	rows = [] #rows will hold the 'href' value to append to coinmarketcap.com for level 2 scraping data
	user_greeting(rows)
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
	choice = gets.chomp.downcase
end

def coin_or_number?(rows)
	puts "Would you like to search by coin, or choose a number in list?"
	sleep(2)
	puts "Enter 'number' or 'n', OR enter 'coin' or 'c'."
	input = gets.chomp
	if input == 'number' || input == 'n'
		puts "Please Select a Currency by it's corresponding number. (ex: '1' for 'Bitcoin')."
		sleep(3)

		scrape_data(rows, 'n') #get coinmarketcap.com current coin listing.
		selection = gets.to_i - 1 #get user's selection of coin
		currency_url = 'https://coinmarketcap.com' +  rows[selection]
		doc = Nokogiri::HTML(URI.open(currency_url))

		coin_name = doc.css('.nameHeader').children[1].children[0]
		coin_price = doc.css('.priceValue').children[0].children[0]
		coin_symbol = doc.css('.nameHeader').children[1].children[1].children[0]

		puts "The current price of #{coin_name} (#{coin_symbol}) is #{coin_price} per coin."
		sleep(2)

	elsif input == 'coin' || input == 'c'
		puts "Please enter the name of a currency."
		sleep(3)
		scrape_data(rows, 'c')
		selection = gets.chomp.downcase

		if rows.include?(selection)
			puts "You've selected #{selection}."
			puts "What would you like to know about #{selection}?"
			options = ["1. Coin Price", "2. % up in last 24 hours.", "3. Circulating Supply", "4. More options..."]

			circulating_supply = doc.css('.statsBlockInner .statsValue').children[0]
			coin_price = doc.css('.priceValue').children[0].children[0]
			coin_symbol = doc.css('.nameHeader').children[1].children[1].children[0]

			more_options = [] #will be fill with additional options to look up.
		end
	else
		puts "Invalid input, please make a proper selection based on instructions.."
		coin_or_number?
	end
end

def scrape_data(rows, letter = '')
	url = 'https://coinmarketcap.com/'
	doc = Nokogiri::HTML(URI.open(url))
	coin_table = doc.css('.cmc-table tbody')
	coin_rows = coin_table.children

	if letter == 'c'
		coin_rows.each.with_index(1) do |coin, index|
			if index.between?(1, 10)
				rows << coin.children[2].css('a')[0].css('div p').children[0].to_s.downcase
			elsif index.between?(11, 50)
				rows << coin.children[2].css('a')[0].children[1].children[0].to_s.downcase
			end
		end
	elsif letter == 'n'
		coin_rows.each.with_index(1) do |coin, index|
			rows << coin.children[2].css('a')[0].attributes["href"].value
			if index.between?(1, 10)
				puts "#{index}. #{coin.children[2].css('a')[0].css('div p').children[0]}"
			elsif index.between?(11, 50)
				puts "#{index}. #{coin.children[2].css('a')[0].children[1].children[0]}"
			end
		end
	end
	
end

def user_greeting(rows)
	coin_or_number?(rows)
end

scrape
