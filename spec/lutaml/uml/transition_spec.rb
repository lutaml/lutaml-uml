# frozen_string_literal: true

require "spec_helper"
require "lutaml/uml"

RSpec.describe Lutaml::Uml::Transition do
  describe "attributes" do
    it "exposes source/target/guard/effect as strings" do
      t = described_class.new(source: "S1", target: "S2",
                              guard: "[ok]", effect: "go")
      expect(t.source).to eq("S1")
      expect(t.target).to eq("S2")
      expect(t.guard).to eq("[ok]")
      expect(t.effect).to eq("go")
    end
  end

  describe "YAML round-trip" do
    it "preserves all four edge attributes" do
      t = described_class.new(source: "S1", target: "S2",
                              guard: "[ok]", effect: "go")
      reparsed = described_class.from_yaml(t.to_yaml)
      expect(reparsed.source).to eq("S1")
      expect(reparsed.target).to eq("S2")
      expect(reparsed.guard).to eq("[ok]")
      expect(reparsed.effect).to eq("go")
    end
  end
end
