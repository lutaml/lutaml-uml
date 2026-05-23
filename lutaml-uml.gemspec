# frozen_string_literal: true

require_relative "lib/lutaml/uml/version"

Gem::Specification.new do |spec|
  spec.name          = "lutaml-uml"
  spec.version       = Lutaml::Uml::VERSION
  spec.authors       = ["Ribose Inc."]
  spec.email         = ["open.source@ribose.com"]

  spec.summary       = "UML domain models, repository, CLI, and SPA generator for LutaML"
  spec.description   = "Provides UML domain model classes, XMI/QEA parsers, CLI, " \
                        "a repository pattern for querying and presenting UML documents, " \
                        "EA diagram rendering, and a static site generator with a Vue.js SPA frontend."
  spec.homepage      = "https://github.com/lutaml/lutaml-uml"
  spec.license       = "MIT"

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = spec.homepage
  spec.metadata["changelog_uri"] = "https://github.com/lutaml/lutaml-uml/releases"
  spec.metadata["rubygems_mfa_required"] = "true"

  spec.files = Dir.chdir(File.expand_path(__dir__)) do
    `git ls-files -z`
      .split("\x0")
      .reject { |f| f.match(%r{^(test|spec|features)/}) }
      .concat(Dir.glob("frontend/dist/*"))
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.required_ruby_version = ">= 3.2.0"

  spec.add_dependency "htmlentities"
  spec.add_dependency "liquid"
  spec.add_dependency "lutaml-model", "~> 0.8.0"
  spec.add_dependency "lutaml-path"
  spec.add_dependency "nokogiri", "~> 1.18"
  spec.add_dependency "paint"
  spec.add_dependency "rubyzip", "~> 2.3"
  spec.add_dependency "sinatra", "~> 4.2"
  spec.add_dependency "sqlite3"
  spec.add_dependency "table_tennis"
  spec.add_dependency "thor", "~> 1.4"
  spec.add_dependency "xmi", "~> 0.5", ">= 0.5.2"
end
