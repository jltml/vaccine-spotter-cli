###
# This is basically a wrapper aroung https://vaccinespotter.org
# It'll alert you based on the condtions on line 22
# Uncomment the last bit of that line to filter by vaccine type, or adust it to however you prefer
###


require "open-uri"
require "json"
require "net/http"
require "terminal-notifier"

state = "XY" # Enter your state's two-letter abbreviation here
zips = [00000,11111,etc] # Enter your ZIP codes here, as integers (i.e. without quotations). You can get the ZIP codes around a radius in a state from https://www.freemaptools.com/find-zip-codes-inside-radius.htm

while true

  json = Net::HTTP.get(URI("https://www.vaccinespotter.org/api/v0/states/#{state}.json"))
  parsed_json = JSON.parse(json)
  puts
    parsed_json["features"].each_index do |i|
      current = parsed_json["features"][i]["properties"]
      if (current["appointments_available"] == true) and (zips.include?(current["postal_code"].to_i) == true) # and (current["appointment_vaccine_types"]["pfizer"] == true or current["appointment_vaccine_types"]["unknown"] == true)
        puts "- #{current["city"]} #{current["provider_brand_name"]}: #{current["url"]}"
        puts " - #{current["appointment_vaccine_types"]} as of #{Time.parse(current["appointments_last_fetched"]).localtime.strftime("%H:%M:%S")}"
        TerminalNotifier.notify("#{current["provider_brand_name"]} - #{current["city"]}", :title => "vaccine-spotter", :open => "#{current["url"]}")
      end
    end

  puts "Checked at #{Time.now.strftime("%H:%M:%S")} on #{Time.now.strftime("%Y-%m-%d")}"

  sleep 10

end
