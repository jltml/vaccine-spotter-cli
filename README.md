# vaccine-finder — a CLI

### Update: now on RubyGems(!)
This is my first gem ever! I'm hoping that I can also make it into a Homebrew formula soon, too. For now, install with `gem install vaccine-finder` or see the installation section below.

## Notes
As of right now, the only places I've written scripts for are:
1. a command-line wrapper around the incredible https://vaccinespotter.org ([GitHub repo](https://github.com/GUI/covid-vaccine-spotter)), using their very beta API, that will check for appointments matching a set of conditions and send a notification when one is found (I still need to make it not send duplicate notifications, though so…).
2. Cub (in Minnesota) — I noticed that they weren't included on https://www.vaccinespotter.org, and they have one of those annoying websites that only shows appointments at locations within a 10 or 25 mile radius… so I compiled a list of the ZIP codes of all Cubs in Minnesota and made a simple Ruby script to check each one. I had to do some finessing with the cookies and session IDs, which is why it opens Chrome (to obtain the cookie), but it seems to be working (mostly?) thus far, though I have yet to see an opening. *Update: I think something might have changed with the way the Cub website handles ZIP code checking? It sometimes returns a blank string (normally it says 'no locations available…'), and I'm not sure what that means. I hope to figure it out soon.*

## Installation

### Prerequisites
- **Ruby** and Bundler, preferably installed with [rbenv](https://github.com/rbenv/rbenv)… or something else, I guess, but I'm very partial to rbenv (tested against Ruby 3.0.1)
- **Chrome**, if you're using the Cub script (it opens it to get a cookie)

### Actually installing

**For the vaccinespotter.org API CLI:**

```sh
gem install vaccine-finder
```

**For the Cub script or for development:**

0. `cd` to a folder where you'd like to download this
1. Clone this repo with `git clone https://github.com/jltml/vaccine-finder.git`
2. Do `cd vaccine-finder` to go to the project's folder
3. Run `bundle install` to install dependencies

## Usage

**For the vaccinespotter.org API CLI:**

```sh
vaccine-finder
```

The first time you run `vaccine-finder`, it will guide you through creating a configuration file at ~/.config/vaccine-finder.toml. The CLI currently doesn't parse options, since I haven't had the chance to add that yet (so there's no `--help` or `-v` or anything yet).


**For the Cub script:**

First, `cd` to where you cloned the project, then run:

```sh
ruby cub-covid-vaccine-finder.rb
```

That's it! I hope to add options and other pharmacies soon.

*If the above doesn't work, try `bundle exec ruby cub-covid-vaccine-finder.rb`*
