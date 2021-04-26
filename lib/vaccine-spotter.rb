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
require "feep"
require "os"

# Supports https://no-color.org
env_no_color = false if ENV['NO_COLOR']

pastel = Pastel.new(enabled: env_no_color)
config = TTY::Config.new
prompt = TTY::Prompt.new(enable_color: env_no_color)

config.filename = "vaccine-spotter"
config.extname = ".toml"
config.append_path "#{Dir.home}/.config"

if OS.windows?
  puts
  print pastel.bold.red "(!) Note: Windows is unsupported"
  puts pastel.red " (I don't have a Windows computer and I barely know how it works)."
  puts pastel.red "Notifications don't work, I think, and sounds require installing `sounder`. Read more at the project homepage: https://github.com/jltml/vaccine-spotter-cli"
end

if !config.exist?
  begin
    puts
    puts pastel.bold "Hi, welcome to the unofficial vaccinespotter.org CLI notifier thing!"
    puts "It looks like you don't have a configuration file yet. Would you like to create one?"
    create_config = prompt.yes? "Create `~/.config/vaccine-spotter.toml`?"
    if !create_config
      puts pastel.bold.red "You'll need to create a configuration file at `~/.config/vaccine-spotter.toml` to use this."
    end
    if create_config
      set_state = prompt.ask("What #{pastel.bold.underline "state"} would you like to monitor? (Two-letter postal code, please)", required: true) do |q|
        q.modify :up, :remove
        # q.validate(^(?-i:A[LKSZRAEP]|C[AOT]|D[EC]|F[LM]|G[AU]|HI|I[ADLN]|K[SY]|LA|M[ADEHINOPST]|N[CDEHJMVY]|O[HKR]|P[ARW]|RI|S[CD]|T[NX]|UT|V[AIT]|W[AIVY])) # This is supposed to validate but doesn't work # Validates state abbreviation, apparently
      end
      config.set(:state, value: set_state)
      puts "Ok, time to set zip codes…"
      if prompt.yes? "freemaptools.com has a really helpful tool for getting the zip codes around a radius. Would you like to open it?"
        Launchy.open "https://www.freemaptools.com/find-zip-codes-inside-radius.htm"
      end
      set_zips = prompt.ask("What #{pastel.bold.underline "zip codes"} would you like to track? You can paste here from freemaptools.com, if you used it (comma-separated list of integers, please)", convert: :int_list, required: true)
      config.set(:zips, value: set_zips)
      set_vaccine_types = prompt.multi_select("Which types of vaccines would you like to include?", %w(pfizer moderna jj unknown), min: 1, show_help: :always)
      config.set(:vaccine_types, value: set_vaccine_types)
      set_refresh_rate = prompt.ask("How often should the script check for updates? (seconds)", convert: :int, required: true)
      config.set(:refresh_rate, value: set_refresh_rate)
      set_play_sound = prompt.yes?("Would you like to play a sound when availability is found?", required: true)
      config.set(:sound, :play, value: set_play_sound)
      if set_play_sound
        set_repeat_sound = prompt.ask("How many times should the sound repeat?", convert: :int, required: true)
        config.set(:sound, :repeat, value: set_repeat_sound)
      end
      puts "Perfect; writing to `~/.config/vaccine-spotter.toml`…"
      config.write
    end

  rescue Interrupt
    puts
    print pastel.red.underline "vaccine-spotter was interrupted during config setup — ~/.config/vaccine-spotter.toml was "
    puts pastel.red.underline.bold "not created"
    exit 1
  end
end

zips = config.read["zips"]
state = config.read["state"]
refresh_rate = config.read["refresh_rate"].to_i
vaccine_types = config.read["vaccine_types"]
play_sound = config.read["sound"]["play"]
repeat_sound = config.read["sound"]["repeat"].to_i

def pluralize(number, text)
  return text + 's' if number != 1
  text
end

def blues_scale
  Feep::Base.new(
    :freq_or_note => 'E4',
    :scale => 'blues',
    :waveform => 'triangle',
    :volume => 0.8,
    :duration => 100,
    :save => false,
    :verbose => false,
    :visual_cue => false,
    :usage => nil
  )
end

puts
print pastel.bold "vaccinespotter.org CLI notifier thing"
begin
  print " v#{Gem.loaded_specs["vaccine-spotter"].version}"
rescue
  print " [error loading version]"
end
puts pastel.dim ", by Jack MapelLentz (jltml.me)"
puts pastel.dim "This script uses the wonderful vaccinespotter.org, by Nick Muerdter (github.com/GUI)"
print "Checking #{pastel.underline zips.length} zip codes in #{pastel.underline state} "
if $loop != false
  puts "every #{pastel.underline refresh_rate} seconds"
else
  puts pastel.underline "once"
end
puts "Filtering appointments for #{pastel.underline vaccine_types.to_s.tr("[]\"", "")}"
if play_sound
  puts "Playing a sound #{pastel.underline repeat_sound} #{pluralize(repeat_sound, "time")} when availability is found"
else
  puts "#{pastel.underline "Not"} playing a sound when availability is found"
end
puts pastel.dim "Press control-C to quit"

excluded = Hash.new

begin

  loop do

    initial_number_excluded = excluded.length

    json = Net::HTTP.get(URI("https://www.vaccinespotter.org/api/v0/states/#{state}.json"))
    parsed_json = JSON.parse(json)

    puts

    new_appointment = false

    # This is the main area thing — it loops through each zip code and finds matches
    parsed_json["features"].each_index do |i|
      current = parsed_json["features"][i]["properties"]

      # Checks if locations that previously had appointments no longer have availability
      if (excluded.keys.include? current["id"]) && (current["appointments_available"] == false)
        print "- "
        puts pastel.red "#{pastel.bold current["city"].split.map(&:capitalize).join(' ') + ' ' + current["provider_brand_name"]}: Appointments no longer available as of #{Time.parse(current["appointments_last_fetched"]).localtime.strftime("%H:%M:%S")}"
        excluded.delete current["id"]
        initial_number_excluded = excluded.length
      end

      # Finds matches
      if (current["appointments_available"] == true) && (zips.include?(current["postal_code"].to_i) && (!excluded.include? current["id"].to_i) && (vaccine_types & current["appointment_vaccine_types"].keys).any?)

        # Logs matches to terminal (and uniformly capitalizes location names)
        puts "- #{pastel.green.bold current["city"].split.map(&:capitalize).join(' ')} #{pastel.green.bold current["provider_brand_name"]}: #{current["url"]}"
        puts " - #{current["appointment_vaccine_types"].keys.to_s.tr("[]\"", "").split.map(&:capitalize).join(' ')} available as of #{Time.parse(current["appointments_last_fetched"]).localtime.strftime("%H:%M:%S")}"

        # Sends a notification if on macOS (also makes location names all the same title case/capitalization)
        if OS.mac? then TerminalNotifier.notify("#{current["provider_brand_name"]} - #{current["city"].split.map(&:capitalize).join(' ')} (#{current["appointment_vaccine_types"].keys.to_s.tr("[]\"", "").split.map(&:capitalize).join(' ')})", :title => "vaccine-spotter", :open => "#{current["url"]}") end

        excluded[current["id"].to_i] = current["appointments_last_fetched"] # Add key & value of {"id" => "appointments_last_fetched"} to excluded hash
        new_appointment = true
      end
    end

    print pastel.dim "Checked at #{Time.now.strftime("%H:%M:%S")} on #{Time.now.strftime("%Y-%m-%d")}"
    if initial_number_excluded != 0
      print pastel.dim " (#{initial_number_excluded} checked #{pluralize(initial_number_excluded, "location")} excluded)"
    end
    puts

    # Plays a sound (E blues scale) if there's a new appointment in a new thread so the whole program isn't delayed by the sound playing
    if play_sound && new_appointment
      Thread.new {
        repeat_sound.times do
          blues_scale
          sleep 0.5
        end
      }
    end

    break if $loop == false

    sleep refresh_rate

  end

rescue Interrupt
  print " "
  puts pastel.underline "Stopping vaccine-spotter…"
  exit
end
