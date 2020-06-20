require 'spec_helper'

RSpec.describe Lutaml::Uml::Parsers::Yaml do
  describe '.parse' do
    subject(:parse) { described_class.parse(yaml_conent) }

    let(:yaml_conent) do
      File.read(fixtures_path('datamodel/views/CommonModels.yml'))
    end

    it 'creates Lutaml::Uml::Node::Document object from yaml' do
      expect(parse).to be_instance_of(Lutaml::Uml::Node::Document)
    end
  end
end
