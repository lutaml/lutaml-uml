# frozen_string_literal: true

require "spec_helper"
require "lutaml/uml"

RSpec.describe Lutaml::Uml::Connector do
  describe "attributes" do
    it "exposes :kind as a string" do
      connector = described_class.new(kind: "association")
      expect(connector.kind).to eq("association")
    end

    it "exposes :connector_end as a collection" do
      connector = described_class.new(connector_end: ["end1", "end2"])
      expect(connector.connector_end).to eq(["end1", "end2"])
    end

    it "defaults :connector_end to an empty array" do
      expect(described_class.new.connector_end).to eq([])
    end
  end

  describe "YAML round-trip" do
    it "preserves kind and connector_end" do
      connector = described_class.new(kind: "association",
                                      connector_end: ["a", "b"])
      reparsed = described_class.from_yaml(connector.to_yaml)
      expect(reparsed.kind).to eq("association")
      expect(reparsed.connector_end).to eq(["a", "b"])
    end
  end
end
