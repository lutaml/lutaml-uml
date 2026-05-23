# frozen_string_literal: true

require "bundler/setup"
require "lutaml/uml"
require "lutaml/uml_repository"
require "lutaml/converter"
require "lutaml/ea"
require "lutaml/xmi"
require "lutaml/qea"
require "lutaml/model_transformations"

RSpec.configure do |config|
  config.disable_monkey_patching!

  config.expect_with :rspec do |c|
    c.syntax = :expect
  end
end

def fixtures_path(path)
  File.join(File.expand_path("./fixtures", __dir__), path)
end

def by_name(entries, name)
  entries.detect { |n| n.name == name }
end

def temp_lur_path(prefix: "test")
  File.join(Dir.tmpdir,
            "#{prefix}#{Process.pid}-#{rand(0x1000000).to_s(36)}.lur")
end

Dir[File.expand_path("./support/**/*.rb", __dir__)].each do |f|
  require f
end
