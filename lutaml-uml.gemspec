# frozen_string_literal: true

require_relative "lib/lutaml/uml/version"

Gem::Specification.new do |spec|
  spec.name          = "lutaml-uml"
  spec.version       = Lutaml::Uml::VERSION
  spec.authors       = ["Ribose Inc."]
  spec.email         = ["open.source@ribose.com'"]

  spec.summary       = "UML model module for LutaML."
  spec.description   = "UML model module for LutaML."
  spec.homepage      = "https://github.com/lutaml/lutaml-uml"
  spec.license       = "MIT"

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = spec.homepage
  spec.metadata["changelog_uri"] = "https://github.com/lutaml/lutaml-uml/releases"

  spec.files         = `git ls-files`.split("\n")
  spec.test_files    = `git ls-files -- {spec}/*`.split("\n")

  spec.bindir        = "exe"
  spec.require_paths = ["lib"]
  spec.executables   = %w[lutaml-uml]

  spec.add_runtime_dependency "activesupport", "~> 5.0"
  spec.add_runtime_dependency "hashie", "~> 4.1.0"
  spec.add_runtime_dependency "lutaml", "~> 0.3.0"
  spec.add_runtime_dependency "parslet", "~> 1.7.1"
  spec.add_runtime_dependency "ruby-graphviz", "~> 1.2"
  spec.add_runtime_dependency "thor", "~> 1.0"

  spec.add_development_dependency "byebug"
  spec.add_development_dependency "nokogiri", "~> 1.10"
  spec.add_development_dependency "rubocop", "~> 0.54.0"
  spec.add_development_dependency "bundler", "~> 2.0"
  spec.add_development_dependency "pry", "~> 0.12.2"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec", "~> 3.0"
end
