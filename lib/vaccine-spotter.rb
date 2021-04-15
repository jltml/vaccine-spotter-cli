#################################################################
# This is basically a wrapper around https://vaccinespotter.org #
#################################################################

require "open-uri"
require "json"
require "net/http"
require "terminal-notifier"
require "pastel"
require "toml"
require "tty-config"
require "tty-prompt"
require "launchy"

pastel = Pastel.new
config = TTY::Config.new
prompt = TTY::Prompt.new

config.filename = "vaccine-spotter"
config.extname = ".toml"
config.append_path "#{Dir.home}/.config"

if !config.exist?
  puts
  puts pastel.bold "Hi, welcome to the unofficial vaccinespotter.org CLI notifier thing!"
  puts "It looks like you don't have a configuration file yet. Would you like to create one?"
  create_config = prompt.yes? "Create `~/.config/vaccine-spotter.toml`?"
  if create_config
    set_state = prompt.ask("What state would you like to monitor? (Two-letter postal code, please)", required: true) do |q|
      q.modify :up, :remove
    end
    config.set(:state, value: set_state)
    puts "Ok, time to set zip codes…"
    if prompt.yes? "freemaptools.com has a really helpful tool for getting the zip codes around a radius. Would you like to open it?"
      Launchy.open "https://www.freemaptools.com/find-zip-codes-inside-radius.htm"
    end
    set_zips = prompt.ask("What zip codes would you like to track? You can paste here from freemaptools.com, if you used it (comma-separated list of integers, please)", convert: :int_list, required: true)
    config.set(:zips, value: set_zips)
    set_vaccine_types = prompt.multi_select("Which types of vaccines would you like to include?", %w(pfizer moderna jj unknown), min: 1, show_help: :always)
    config.set(:vaccine_types, value: set_vaccine_types)
    set_refresh_rate = prompt.ask("How often should the script check for updates? (seconds)", convert: :int, required: true)
    config.set(:refresh_rate, value: set_refresh_rate)
    puts "Perfect; writing to `~/.config/vaccine-spotter.toml`…"
    config.write
  end
end

zips = config.read["zips"]
state = config.read["state"]
refresh_rate = config.read["refresh_rate"].to_i
vaccine_types = config.read["vaccine_types"]

puts
print pastel.bold "vaccinespotter.org CLI notifier thing"
begin
  print " v#{Gem.loaded_specs["vaccine-spotter"].version}"
rescue
  print " [error loading version]"
end
puts pastel.dim ", by Jack MapelLentz (jltml.me)"
puts pastel.dim "This script uses the wonderful vaccinespotter.org, by Nick Muerdter (github.com/GUI)"
puts "Checking #{pastel.underline zips.length} zip codes in #{pastel.underline state} every #{pastel.underline refresh_rate} seconds"
puts "Filtering appointments for #{pastel.underline vaccine_types.to_s.tr("[]\"", "")}"
puts pastel.dim "Press control-C to quit"

excluded = Array.new

loop do

  number_excluded = excluded.length

  json = Net::HTTP.get(URI("https://www.vaccinespotter.org/api/v0/states/#{state}.json"))
  parsed_json = JSON.parse(json)

  puts

  if (Time.now.strftime("%M").to_i%5 == 0) && (Time.now.strftime("%S").to_i < refresh_rate)
    excluded.clear
    puts "List of excluded/checked stores cleared"
  end

  parsed_json["features"].each_index do |i|
    current = parsed_json["features"][i]["properties"]
    if (current["appointments_available"] == true) and (zips.include?(current["postal_code"].to_i) and (!excluded.include? current["id"].to_i) and !(vaccine_types & current["appointment_vaccine_types"].keys).empty?)
      puts "- #{pastel.green.bold current["city"]} #{pastel.green.bold current["provider_brand_name"]}: #{current["url"]}"
      puts " - #{current["appointment_vaccine_types"]} as of #{Time.parse(current["appointments_last_fetched"]).localtime.strftime("%H:%M:%S")}"
      TerminalNotifier.notify("#{current["provider_brand_name"]} - #{current["city"]}", :title => "vaccine-spotter", :open => "#{current["url"]}")
      excluded.append current["id"].to_i
    end
  end

  print pastel.dim "Checked at #{Time.now.strftime("%H:%M:%S")} on #{Time.now.strftime("%Y-%m-%d")}"
  if number_excluded == 1
    print pastel.dim " (#{number_excluded} checked location excluded)"
  elsif number_excluded != 0
    print pastel.dim " (#{number_excluded} checked locations excluded)"
  end
  puts

  sleep refresh_rate

end
