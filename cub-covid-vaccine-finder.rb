# require 'mechanize'
require 'watir'
require 'webdrivers/chromedriver'
require 'curb'
require 'tty-progressbar'
# require 'tty-option'
require 'tty-logger'
require 'date'

Watir.default_timeout = 300
browser = Watir::Browser.new
browser.goto 'https://svu.marketouchmedia.com/SVUSched/program/program1987/Patient/Advisory'
browser.text_field(name: "zip").wait_until(&:present?)
cookie = "ASP.NET_SessionId=0; QueueITAccepted-SDFrts345E-V3_cubsupervalucovid19=#{browser.cookies.to_a[-1][:value]};"
browser.close

#agent = Mechanize.new
# agent.cookie_jar = "cookie_jar"
#page = agent.get('https://svu.marketouchmedia.com/SVUSched/program/program1987/Patient/Advisory').save_cookies
#agent.cookies

# Curl.post("https://reportsonline.queue-it.net/?c=reportsonline&e=cubsupervalucovid19&ver=v3-aspnet-3.6.2&cver=52&man=Cub%20SUPERVALU%20COVID-19", {:zip => "55118"}) do |http|
#  http.enable_cookies = true
#  http.cookiejar = "cookies.txt"
#end

zips = [55008,55016,55025,55033,55044,55057,55068,55076,55082,55104,55106,55109,55110,55112,55113,55117,55118,55119,55122,55123,55124,55125,55126,55127,55128,55313,55316,55317,55318,55330,55331,55337,55344,55345,55362,55369,55374,55376,55378,55379,55406,55408,55411,55413,55416,55419,55420,55421,55422,55426,55428,55430,55431,55432,55433,55434,55435,55441,55442,55445,55447,55448,55449,55811,55904,56001,56201,56308,56401,56425]

bar = TTY::ProgressBar.new("checking… :bar :percent • :eta remaining", total: zips.length, bar_format: :box, clear: true)
logger = TTY::Logger.new

appointments = zips.each { |zip|
  response = Curl.post("https://svu.marketouchmedia.com/SVUSched/program/program1987/Patient/CheckZipCode", {:zip => zip.to_s.strip, :appointmentType => "5947", :PatientInterfaceMode => "0"}) do |http|
    http.headers['Cookie'] = "#{cookie}"
  end
  if response.body_str.include? "Object moved"
    puts
    logger.error "Oops, something went wrong (probably with the cookie)."
    logger.error "cURL body response:"
    puts response.body_str
    puts
    raise "'Object moved' error"
    break
  elsif response.body_str.include? "There are no locations with available appointments within 10 miles of"
    # bar.log(response.body_str)
  else
    bar.log(response.body_str)
  end
  bar.advance
}

logger.success "Checked at #{Time.now.strftime("%H:%M on %Y-%m-%d")}."
