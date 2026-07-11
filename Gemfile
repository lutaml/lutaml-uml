# frozen_string_literal: true

source "https://rubygems.org"

gemspec

# Sibling-repo path dependencies — used during local development when
# the sibling checkout exists (monorepo-style workflow). In CI and for
# gem install, fall back to the published rubygems versions.
%w[lutaml-model ea].each do |sibling_gem|
  sibling_path = File.expand_path("../#{sibling_gem}", __dir__)
  if File.directory?(sibling_path)
    gem sibling_gem, path: sibling_path
  else
    gem sibling_gem
  end
end

gem "rack-test"
gem "rake", "~> 13.0"
gem "rspec", "~> 3.0"
