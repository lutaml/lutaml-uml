# frozen_string_literal: true

require "spec_helper"

RSpec.describe Lutaml::Uml::UmlClass do
  describe ".from_yaml" do
    subject(:test_model) { described_class.from_yaml(yaml_content) }

    let(:yaml_content) do
      File.read(fixtures_path("uml/class.yml"))
    end

    let(:output) { test_model.to_yaml }

    let(:expected_output) do
      <<~YAML
        ---
        name: _Curve
        xmi_id: EAID_83B2B411_0579_4e2d_823D_D22BF0F06064
        stereotype:
        - Type
        visibility: public
        full_name: _Curve
        generalization:
        - id: EAID_97DD0658_254B_46b8_86F2_92CA5FFAE8AC
          type: uml:Generalization
          general: EAID_7FAB8425_4E7D_42e8_94F2_901B0F0C0300
        is_abstract: true
        type: Class
        associations:
        - xmi_id: EAID_35192687_3A64_4b1c_A68E_C5B1D1BB7E8A
          visibility: public
          owner_end: _Curve
          owner_end_xmi_id: EAID_83B2B411_0579_4e2d_823D_D22BF0F06064
          member_end: MultiCurve
          member_end_attribute_name: MultiCurve
          member_end_xmi_id: EAID_B326682E_0384_443a_A119_96FD046071A2
          member_end_type: association
        - xmi_id: EAID_61081D6B_9F19_4108_818A_C69575DC6F41
          visibility: public
          owner_end: _Curve
          owner_end_xmi_id: EAID_83B2B411_0579_4e2d_823D_D22BF0F06064
          member_end: CompositeCurve
          member_end_attribute_name: CompositeCurve
          member_end_xmi_id: EAID_2943D7B6_E646_4e7f_85AA_702C1DF22FBE
          member_end_type: association
      YAML
    end

    it "outputs name" do
      expect(YAML.safe_load(output)["name"]).to eq("_Curve")
    end

    it "outputs full yaml" do
      expect(output).to eq(expected_output)
    end
  end

  describe "attribute management" do
    let(:klass) { described_class.new(name: "Foo") }
    let(:attr)  { Lutaml::Uml::TopElementAttribute.new(name: "bar", type: "String") }

    it "starts with no attributes" do
      expect(described_class.new.attributes.to_a).to eq([])
    end

    it "appends attributes in order" do
      klass.attributes << attr
      klass.attributes << Lutaml::Uml::TopElementAttribute.new(name: "baz")
      expect(klass.attributes.map(&:name)).to eq(%w[bar baz])
    end
  end

  describe "association management" do
    let(:klass) { described_class.new(name: "Foo") }
    let(:assoc) do
      Lutaml::Uml::Association.new(owner_end: "Foo", member_end: "Bar")
    end

    it "starts with no associations" do
      expect(described_class.new.associations.to_a).to eq([])
    end

    it "appends associations" do
      klass.associations << assoc
      expect(klass.associations.size).to eq(1)
      expect(klass.associations.first.member_end).to eq("Bar")
    end
  end

  describe "stereotype handling" do
    it "accepts a single stereotype string" do
      klass = described_class.new(stereotype: "entity")
      # The model stores the value as given; the presenter normalizes
      # to an array for display (see ClassPresenter#stereotype_string).
      expect(Array(klass.stereotype)).to eq(["entity"])
    end

    it "accepts a stereotype array" do
      klass = described_class.new(stereotype: %w[entity featureType])
      expect(klass.stereotype).to eq(%w[entity featureType])
    end

    it "defaults to an empty array" do
      expect(described_class.new.stereotype).to eq([])
    end
  end

  describe "generalization" do
    it "holds a Generalization reference" do
      gen = Lutaml::Uml::Generalization.new(name: "Parent")
      klass = described_class.new(name: "Child")
      klass.generalization = gen
      expect(klass.generalization).to be_a(Lutaml::Uml::Generalization)
      expect(klass.generalization.name).to eq("Parent")
    end
  end

  describe "abstract flag" do
    it "defaults to false" do
      expect(described_class.new.is_abstract).to be(false)
    end

    it "accepts true" do
      expect(described_class.new(is_abstract: true).is_abstract).to be(true)
    end
  end
end
