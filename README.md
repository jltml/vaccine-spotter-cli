# vaccine-spotter — a CLI for vaccinespotter.org
***notifications! filtering! yay!***

![Gem](https://img.shields.io/gem/v/vaccine-spotter)
![GitHub Workflow Status](https://img.shields.io/github/workflow/status/jltml/vaccine-spotter-cli/Release)
![GitHub Workflow Status](https://img.shields.io/github/workflow/status/jltml/homebrew-tap/brew%20test-bot?label=homebrew%20tests)
![GitHub Workflow Status](https://img.shields.io/github/workflow/status/jltml/homebrew-tap/brew%20pr-pull?label=homebrew%20publishing)
![GitHub](https://img.shields.io/github/license/jltml/vaccine-spotter-cli)

![GIF preview of vaccine-spotter command-line interface](https://user-images.githubusercontent.com/8261330/114811965-b0a06180-9d74-11eb-8604-0408ca92acfa.gif)

### Update: now on RubyGems! and Homebrew!
This is my first gem and Homebrew formula ever(!), so please bear with me as I figure out how everything works.

## Installation

### Prerequisites
- **Ruby** (if you install with RubyGems; Homebrew uses the macOS system Ruby)

### Actually installing

Install with Homebrew (probably easiest):

```sh
brew install jltml/tap/vaccine-spotter
```

Install with RubyGems:

```sh
gem install vaccine-spotter
```

## Usage

```sh
vaccine-spotter
```

The first time you run `vaccine-spotter`, it will guide you through creating a configuration file at ~/.config/vaccine-spotter.toml. The CLI currently doesn't parse options, since I haven't had the chance to add that yet (so there's no `--help` or `-v` or anything yet).

That's it! I hope to add options and more soon.

### Notes & Caveats:
- I have pretty much no idea how Windows works, so this might not work on it, and notifications definitely don't work for Windows as of now. Sorry about that.
  - I'm using the [`feep`](https://github.com/michaelchadwick/feep) gem for sounds (if activated in the config). On Windows, this (apparently) requires [`sounder`](http://www.elifulkerson.com/projects/commandline-wav-player.php), a command-line WAV file player. I haven't tested it or anything, though — see [the gem's README](https://github.com/michaelchadwick/feep#feep) for more.

## Development
*If anyone actually uses this, PRs are more than welcome!*

0. `cd` to a folder where you'd like to download this
1. Clone this repo with `git clone https://github.com/jltml/vaccine-spotter-cli.git`
2. Do `cd vaccine-spotter-cli` to go to the project's folder
3. Run `bundle install` to install dependencies
