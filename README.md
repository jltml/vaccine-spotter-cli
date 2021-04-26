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
- **Ruby**
  - Homebrew will use the macOS system Ruby; otherwise, Ruby installed with a version manager like [`asdf`](https://asdf-vm.com) or [`rbenv`](https://github.com/rbenv/rbenv) is probably a good idea.
  - On Windows, try [RubyInstaller](https://rubyinstaller.org) (I've never used it though…)

### Actually installing

#### If you know what you're doing:
Install with [Homebrew](https://brew.sh) (probably easiest):

```sh
brew install jltml/tap/vaccine-spotter
```

Install with [RubyGems](https://rubygems.org):

```sh
gem install vaccine-spotter
```

#### For those of you who've never done anything like this before:
I'm assuming you're using a Mac, since I know Very Little about Windows.
1. Open the application called "Terminal"
2. Copy the following and paste it in Terminal:

```sh
xcode-select --install
```

3. Hit enter and follow anything other instructions that pop up. This will install [some utilities & things](https://developer.apple.com/library/archive/technotes/tn2339/_index.html).
4. After that's all done, go back to Terminal. Copy and paste the following line and then hit enter, just like before:

```sh
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
```

- This installs [Homebrew](https://brew.sh), a [package manager](https://en.wikipedia.org/wiki/Package_manager), which you'll in turn use to install vaccine-spotter. When it asks you about changing permissions and creating files and stuff, just hit enter to say yes. You can test that Homebrew is installed by running `brew --version`. You should get something like `Homebrew 3.1.3-91-gfb7d19c` (which is what I have right now).

5. After you've installed Homebrew, (finally!) copy and paste this to install vaccine-spotter:

```sh
brew install jltml/tap/vaccine-spotter
```

6. You should be all good! Congrats. You can run `vaccine-spotter` in Terminal (just type that and hit enter) and it will guide you through setting it up!

## Usage

```sh
vaccine-spotter
```

The first time you run `vaccine-spotter`, it will guide you through creating a configuration file at ~/.config/vaccine-spotter.toml.

That's it! Run `vaccine-spotter help` to see all commands.

### Notes & Caveats:
- I have pretty much no idea how Windows works, so this might not work on it, and notifications definitely don't work for Windows as of now. Sorry about that.
  - I'm using the [`feep`](https://github.com/michaelchadwick/feep) gem for sounds (if activated in the config). On Windows, this (apparently) requires [`sounder`](http://www.elifulkerson.com/projects/commandline-wav-player.php), a command-line WAV file player. I haven't tested it or anything, though — see [the gem's README](https://github.com/michaelchadwick/feep#feep) for more.

## Development
*If anyone actually uses this, PRs are more than welcome!*

0. `cd` to a folder where you'd like to download this
1. Clone this repo with `git clone https://github.com/jltml/vaccine-spotter-cli.git`
2. Do `cd vaccine-spotter-cli` to go to the project's folder
3. Run `bundle install` to install dependencies
