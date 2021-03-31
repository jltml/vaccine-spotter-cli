***Note: I think something changed with the way the Cub website handles ZIP code checking? It keep returning a blank string (normally it says 'no locations available…'), and I'm not sure what that means. I hope to figure it out soon.***

# covid-vaccine-finders
**CLI app(s) to help you find COVID-19 vaccines.**

The only place this works for right now is Cub (in Minnesota) — I noticed that they weren't included on https://www.vaccinespotter.org ([GitHub](https://github.com/GUI/covid-vaccine-spotter)), and they have one of those annoying websites that only shows appointments at locations within a 10 mile radius… so I compiled a list of the ZIP codes of all Cubs in Minnesota and made a simple Ruby script to check each one. I had to do some finessing with the cookies and session IDs, which is why it opens Chrome (to obtain the cookie), but it seems to be working thus far, though I have yet to see an opening.

## Installation

### Prerequisites
- **Ruby** and Bundler, preferably installed with [rbenv](https://github.com/rbenv/rbenv)… or something else, I guess, but I'm very partial to rbenv (tested against Ruby 3.0.0)
- **Chrome** (which the script will open to get a cookie)

### Actually installing
0. `cd` to a folder where you'd like to download this
1. Clone this repo with `git clone https://github.com/jltml/covid-vaccine-finders.git`
2. Do `cd covid-vaccine-finders` to go to the project's folder
3. Run `bundle install` to install dependencies

## Usage

```sh
ruby cub-covid-vaccine-finder.rb
```

That's it! I hope to add options and other pharmacies soon.

*If the above doesn't work, try `bundle exec ruby cub-covid-vaccine-finder.rb`*
