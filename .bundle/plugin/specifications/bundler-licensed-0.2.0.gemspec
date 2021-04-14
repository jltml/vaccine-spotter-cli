# -*- encoding: utf-8 -*-
# stub: bundler-licensed 0.2.0 ruby lib

Gem::Specification.new do |s|
  s.name = "bundler-licensed".freeze
  s.version = "0.2.0"

  s.required_rubygems_version = Gem::Requirement.new(">= 0".freeze) if s.respond_to? :required_rubygems_version=
  s.metadata = { "changelog_uri" => "https://github.com/sergey-alekseev/bundler-licensed/blob/master/CHANGELOG.md", "homepage_uri" => "https://github.com/sergey-alekseev/bundler-licensed", "source_code_uri" => "https://github.com/sergey-alekseev/bundler-licensed" } if s.respond_to? :metadata=
  s.require_paths = ["lib".freeze]
  s.authors = ["Sergey Alekseev".freeze]
  s.bindir = "exe".freeze
  s.date = "2020-10-27"
  s.description = "Use a Bundler hook to automatically run `licensed cache -s bundler`\nafter running `bundle install` or `bundle update` commands.\n".freeze
  s.email = ["code+bundlerlicensed@sergeyalekseev.com".freeze]
  s.homepage = "https://github.com/sergey-alekseev/bundler-licensed".freeze
  s.licenses = ["MIT".freeze]
  s.required_ruby_version = Gem::Requirement.new(">= 2.5".freeze)
  s.rubygems_version = "3.2.16".freeze
  s.summary = "A bundler hook for https://github.com/github/licensed".freeze

  s.installed_by_version = "3.2.16" if s.respond_to? :installed_by_version

  if s.respond_to? :specification_version then
    s.specification_version = 4
  end

  if s.respond_to? :add_runtime_dependency then
    s.add_development_dependency(%q<bundler>.freeze, ["~> 2.1.4"])
    s.add_development_dependency(%q<licensed>.freeze, ["~> 2.12"])
    s.add_development_dependency(%q<rake>.freeze, ["~> 10.0"])
    s.add_development_dependency(%q<rspec>.freeze, ["~> 3.0"])
    s.add_development_dependency(%q<rubocop>.freeze, ["~> 1.0"])
  else
    s.add_dependency(%q<bundler>.freeze, ["~> 2.1.4"])
    s.add_dependency(%q<licensed>.freeze, ["~> 2.12"])
    s.add_dependency(%q<rake>.freeze, ["~> 10.0"])
    s.add_dependency(%q<rspec>.freeze, ["~> 3.0"])
    s.add_dependency(%q<rubocop>.freeze, ["~> 1.0"])
  end
end
