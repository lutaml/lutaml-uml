require 'spec_helper'

RSpec.describe Lutaml::Uml::Parsers::Yaml do
  describe '.parse' do
    subject(:parse) { described_class.parse(yaml_conent) }

    let(:yaml_conent) do
      fixtures_path('datamodel/views/TopDown.yml')
    end

    it 'creates Lutaml::Uml::Document object from yaml' do
      expect(parse).to be_instance_of(Lutaml::Uml::Document)
      expect(parse.classes.first).to be_instance_of(Lutaml::Uml::Class)
    end

    it 'Lutaml::Uml::Formatter::Graphviz understands the format of document' do
      expect {
        Lutaml::Uml::Formatter::Graphviz.new.format(parse)
      }.to_not(raise_error)
    end
  end
end
