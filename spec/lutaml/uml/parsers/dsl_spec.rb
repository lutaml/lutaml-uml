# frozen_string_literal: true

require "spec_helper"

RSpec.describe Lutaml::Uml::Parsers::Dsl do
  describe ".parse" do
    subject(:parse) { described_class.parse(conent) }
    subject(:format_parsed_document) do
      Lutaml::Uml::Formatter::Graphviz.new.format_document(parse)
    end

    shared_examples 'the correct graphviz formatting' do
      it 'does not raise error on graphviz formatting' do
        expect { format_parsed_document }.to_not raise_error
      end
    end

    context "when simple diagram without attributes" do
      let(:conent) do
        File.read(fixtures_path("dsl/diagram.lutaml"))
      end

      it "creates Lutaml::Uml::Document object from supplied dsl" do
        expect(parse).to be_instance_of(Lutaml::Uml::Document)
      end

      it_behaves_like 'the correct graphviz formatting'
    end

    context "when diagram with attributes" do
      let(:conent) do
        File.read(fixtures_path("dsl/diagram_attributes.lutaml"))
      end

      it "creates Lutaml::Uml::Document object and sets its attributes" do
        expect(parse).to be_instance_of(Lutaml::Uml::Document)
        expect(parse.title).to eq("my diagram")
      end

      it_behaves_like 'the correct graphviz formatting'
    end

    context "when multiply classes entries" do
      let(:conent) do
        File.read(fixtures_path("dsl/diagram_multiply_classes.lutaml"))
      end

      it "creates Lutaml::Uml::Document object and creates dependent classes" do
        expect(parse).to be_instance_of(Lutaml::Uml::Document)
        expect(parse.classes.length).to eq(3)
      end

      it_behaves_like 'the correct graphviz formatting'
    end
  end
end
