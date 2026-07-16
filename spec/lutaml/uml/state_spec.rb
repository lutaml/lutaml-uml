# frozen_string_literal: true

require "spec_helper"
require "lutaml/uml"

RSpec.describe Lutaml::Uml::State do
  describe "attributes" do
    it "exposes entry/exit/do_activity as strings" do
      state = described_class.new(entry: "enter", exit: "leave", do_activity: "work")
      expect(state.entry).to eq("enter")
      expect(state.exit).to eq("leave")
      expect(state.do_activity).to eq("work")
    end
  end

  describe "YAML round-trip" do
    it "preserves entry/exit/do_activity" do
      state = described_class.new(entry: "enter", exit: "leave", do_activity: "work")
      reparsed = described_class.from_yaml(state.to_yaml)
      expect(reparsed.entry).to eq("enter")
      expect(reparsed.exit).to eq("leave")
      expect(reparsed.do_activity).to eq("work")
    end
  end
end
