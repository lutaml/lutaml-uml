# frozen_string_literal: true

require_relative "lib/lutaml/uml/version"

Gem::Specification.new do |spec|
  spec.name          = "lutaml-uml"
  spec.version       = Lutaml::Uml::VERSION
  spec.authors       = ["Ribose Inc."]
  spec.email         = ["open.source@ribose.com"]

  spec.summary       = "UML domain models, repository, and SPA generator for LutaML"
  spec.description   = "Provides UML domain model classes, a repository pattern for " \
                        "querying and presenting UML documents, LUR (.lur) package " \
                        "serialization, and a static site generator with a Vue.js SPA " \
                        "frontend. Use the companion `ea` gem to parse Sparx EA files " \
                        "into Lutaml::Uml::Documents."
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

  spec.add_dependency "lutaml-model", "~> 0.8.0"
  spec.add_dependency "rubyzip", "~> 2.3"
end
