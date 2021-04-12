###
# This is basically a wrapper aroung https://vaccinespotter.org
# It'll alert you based on the condtions on line 22
# Uncomment the last bit of that line to filter by vaccine type, or adust it to however you prefer
###


require "open-uri"
require "json"
require "net/http"
require "terminal-notifier"
require "pastel"

refresh_rate = 10 # refresh rate, in seconds
state = "XY" # Enter your state's two-letter abbreviation here
zips = [00000,11111,22222] # Enter your ZIP codes here, as integers (i.e. without quotations). You can get the ZIP codes around a radius in a state from https://www.freemaptools.com/find-zip-codes-inside-radius.htm

pastel = Pastel.new

puts
puts pastel.bold "vaccine-spotter, by Jack MapelLentz (jltml.me)"
puts pastel.dim "Version […very beta lol; no version yet]"
puts pastel.dim "This script uses the wonderful vaccinespotter.org, by Nick Muerdter (github.com/GUI)"
puts "Checking #{pastel.underline zips.length} ZIP codes in #{pastel.underline state} every #{pastel.underline refresh_rate} seconds"

excluded = Array.new

loop do

  number_excluded = excluded.length

  json = Net::HTTP.get(URI("https://www.vaccinespotter.org/api/v0/states/#{state}.json"))
  parsed_json = JSON.parse(json)
  puts

  parsed_json["features"].each_index do |i|
    current = parsed_json["features"][i]["properties"]
    if (current["appointments_available"] == true) and (zips.include?(current["postal_code"].to_i) == true) and (current["appointment_vaccine_types"]["pfizer"] == true or current["appointment_vaccine_types"]["unknown"] == true) and (!excluded.include? current["postal_code"].to_i)
      puts "- #{pastel.green.bold current["city"]} #{pastel.green.bold current["provider_brand_name"]}: #{current["url"]}"
      puts " - #{current["appointment_vaccine_types"]} as of #{Time.parse(current["appointments_last_fetched"]).localtime.strftime("%H:%M:%S")}"
      TerminalNotifier.notify("#{current["provider_brand_name"]} - #{current["city"]}", :title => "vaccine-spotter", :open => "#{current["url"]}")
      excluded.append current["postal_code"].to_i
    end
  end

  print pastel.dim "Checked at #{Time.now.strftime("%H:%M:%S")} on #{Time.now.strftime("%Y-%m-%d")}"
  if number_excluded == 1
    print pastel.dim " (#{number_excluded} checked ZIP code excluded)"
  elsif number_excluded != 0
    print pastel.dim " (#{number_excluded} checked ZIP codes excluded)"
  end
  puts

  if (Time.now.strftime("%M").to_i%5 == 0) && (Time.now.strftime("%S").to_i < refresh_rate)
    excluded.clear
    puts "List of excluded/checked ZIP codes cleared"
  end

  sleep refresh_rate

end
