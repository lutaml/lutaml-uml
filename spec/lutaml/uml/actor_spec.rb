# frozen_string_literal: true

require "spec_helper"
require "lutaml/uml"

RSpec.describe Lutaml::Uml::Actor do
  it "is a UmlClassifier" do
    expect(described_class.ancestors).to include(Lutaml::Uml::UmlClassifier)
  end

  it "inherits the name attribute from TopElement" do
    actor = described_class.new(name: "Customer")
    expect(actor.name).to eq("Customer")
  end

  it "round-trips through YAML with a name" do
    actor = described_class.new(name: "Customer")
    reparsed = described_class.from_yaml(actor.to_yaml)
    expect(reparsed.name).to eq("Customer")
  end
end
