# frozen_string_literal: true

require "spec_helper"

RSpec.describe Lutaml::Uml::Parsers::Dsl do
  describe ".parse" do
    subject(:parse) { described_class.parse(content) }
    subject(:format_parsed_document) do
      Lutaml::Uml::Formatter::Graphviz.new.format_document(parse)
    end

    shared_examples "the correct graphviz formatting" do
      it "does not raise error on graphviz formatting" do
        expect { format_parsed_document }.to_not raise_error
      end
    end

    context "when simple diagram without attributes" do
      let(:content) do
        File.read(fixtures_path("dsl/diagram.lutaml"))
      end

      it "creates Lutaml::Uml::Document object from supplied dsl" do
        expect(parse).to be_instance_of(Lutaml::Uml::Document)
      end

      it_behaves_like "the correct graphviz formatting"
    end

    context "when diagram with attributes" do
      let(:content) do
        File.read(fixtures_path("dsl/diagram_attributes.lutaml"))
      end

      it "creates Lutaml::Uml::Document object and sets its attributes" do
        expect(parse).to be_instance_of(Lutaml::Uml::Document)
        expect(parse.title).to eq("my diagram")
      end

      it_behaves_like "the correct graphviz formatting"
    end

    context "when multiply classes entries" do
      let(:content) do
        File.read(fixtures_path("dsl/diagram_multiply_classes.lutaml"))
      end

      it "creates Lutaml::Uml::Document object and creates dependent classes" do
        expect(parse).to be_instance_of(Lutaml::Uml::Document)
        expect(parse.classes.length).to eq(3)
      end

      it_behaves_like "the correct graphviz formatting"
    end

    context "when class with fields" do
      let(:content) do
        File.read(fixtures_path("dsl/diagram_class_fields.lutaml"))
      end

      it "creates the correct classes and sets the \
          correct number of attributes" do
        classes = parse.classes
        expect(by_name(classes, "Component").attributes).to be_nil
        expect(by_name(classes, "AddressClassProfile")
                .attributes.length).to eq(1)
        expect(by_name(classes, "AttributeProfile")
                .attributes.length).to eq(7)
      end

      it "creates the correct attributes with the correct visibility" do
        attributes = by_name(parse.classes, "AttributeProfile").attributes
        expect(by_name(attributes, "imlicistAttributeProfile").visibility)
          .to be_nil
        expect(by_name(attributes, "attributeProfile").visibility)
          .to eq("public")
        expect(by_name(attributes, "privateAttributeProfile").visibility)
          .to eq("private")
        expect(by_name(attributes, "friendlyAttributeProfile").visibility)
          .to eq("friendly")
        expect(by_name(attributes, "protectedAttributeProfile").visibility)
          .to eq("protected")
      end

      it_behaves_like "the correct graphviz formatting"
    end

    context "when association blocks exists" do
      let(:content) do
        File.read(fixtures_path("dsl/diagram_class_assocation.lutaml"))
      end

      it "creates the correct number of associations" do
        expect(parse.associations.length).to eq(3)
      end

      context "when bidirectional asscoiation syntax " do
        subject(:association) do
          by_name(parse.associations, "BidirectionalAsscoiation")
        end

        it "creates associations with the correct attributes" do
          expect(association.owner_end_type).to(eq("aggregation"))
          expect(association.member_end_type).to(eq("direct"))
          expect(association.owner_end).to(eq("AddressClassProfile"))
          expect(association.owner_end_attribute_name)
            .to(eq("addressClassProfile"))
          expect(association.member_end).to(eq("AttributeProfile"))
          expect(association.member_end_attribute_name)
            .to(eq("attributeProfile"))
          expect(association.member_end_cardinality).to(eq(min: "0", max: "*"))
        end
      end

      context "when direct asscoiation syntax " do
        subject(:association) do
          by_name(parse.associations, "DirectAsscoiation")
        end

        it "creates associations with the correct attributes" do
          expect(association.owner_end_type).to(be_nil)
          expect(association.member_end_type).to(eq("direct"))
          expect(association.owner_end).to(eq("AddressClassProfile"))
          expect(association.owner_end_attribute_name).to(be_nil)
          expect(association.member_end).to(eq("AttributeProfile"))
          expect(association.member_end_attribute_name)
            .to(eq("attributeProfile"))
          expect(association.member_end_cardinality).to(be_nil)
        end
      end

      context "when reverse asscoiation syntax " do
        subject(:association) do
          by_name(parse.associations, "ReverseAsscoiation")
        end

        it "creates associations with the correct attributes" do
          expect(association.owner_end_type).to(eq("aggregation"))
          expect(association.member_end_type).to(be_nil)
          expect(association.owner_end).to(eq("AddressClassProfile"))
          expect(association.owner_end_attribute_name)
            .to(eq("addressClassProfile"))
          expect(association.member_end).to(eq("AttributeProfile"))
          expect(association.member_end_attribute_name).to(be_nil)
          expect(association.member_end_cardinality).to(be_nil)
        end
      end
    end

    context "whene enum entries" do
      let(:content) do
        File.read(fixtures_path("dsl/diagram_enum.lutaml"))
      end

      it "Generates the correct enums list" do
        enums = parse.enums
        expect(by_name(enums, "MyEnum").attributes).to be_nil
        expect(by_name(enums, "AddressClassProfile")
                .attributes.length).to eq(1)
        expect(by_name(enums, "Profile")
                .attributes.length).to eq(5)
      end

      it_behaves_like "the correct graphviz formatting"
    end

    context "when concept model generated lutaml file" do
      let(:content) do
        File.read(fixtures_path("dsl/diagram_concept_model.lutaml"))
      end

      it "Generates the correct class/enums/associations list" do
        document = parse
        expect(document.classes.length).to(eq(9))
        expect(document.enums.length).to(eq(3))
        expect(document.associations.length).to(eq(7))
      end

      it "Generates the correct attributes list" do
        attributes = by_name(parse.classes, 'ExpressionDesignation').attributes
        expect(attributes.length).to(eq(5))
        expect(attributes.map(&:name)).to(eq(%w[text language script pronunciation grammarInfo]))
        expect(attributes.map(&:type))
          .to(eq(["GlossaristTextElementType",
                  "Iso639ThreeCharCode",
                  "Iso15924Code",
                  "<<BasicDocument>> LocalizedString",
                  "GrammarInfo"]))
      end

      it_behaves_like "the correct graphviz formatting"
    end
  end
end
