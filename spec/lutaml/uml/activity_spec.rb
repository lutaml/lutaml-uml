# frozen_string_literal: true

require "spec_helper"
require "lutaml/uml"

RSpec.describe Lutaml::Uml::Activity do
  it "is a Behavior" do
    expect(described_class.ancestors).to include(Lutaml::Uml::Behavior)
  end

  it "can be instantiated with no attributes" do
    expect { described_class.new }.not_to raise_error
  end

  it "round-trips through YAML" do
    activity = described_class.new
    yaml = activity.to_yaml
    reparsed = described_class.from_yaml(yaml)
    expect(reparsed).to be_a(described_class)
  end
end
