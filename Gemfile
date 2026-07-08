# frozen_string_literal: true

source "https://rubygems.org"

gemspec

gem "lutaml-model", github: "lutaml/lutaml-model", branch: "main"
gem "rack-test"
gem "rake", "~> 13.0"
gem "rspec", "~> 3.0"

# Sibling-repo path dependency — used during local development when
# the sibling checkout exists (monorepo-style workflow). In CI and for
# gem install, fall back to the published rubygems version.
ea_path = File.expand_path("../ea", __dir__)
if File.directory?(ea_path)
  gem "ea", path: ea_path
else
  gem "ea"
end
