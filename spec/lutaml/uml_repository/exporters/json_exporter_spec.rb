# frozen_string_literal: true

require "spec_helper"
require_relative "../../../../lib/lutaml/uml_repository/exporters/json_exporter"
require "json"
require "tempfile"

RSpec.describe Lutaml::UmlRepository::Exporters::JsonExporter do
  # Real UmlClass instance — exercises the actual attribute readers
  # the exporter calls. No doubles.
  let(:uml_class) do
    Lutaml::Uml::UmlClass.new(
      xmi_id: "class1",
      name: "Building",
      stereotype: ["featureType"],
      definition: "A building structure",
    )
  end

  # Minimal fake repository exposing the methods JsonExporter calls:
  # `indexes`, `statistics`, `list_packages`, `all_diagrams`,
  # `supertype_of`. Real model instances where the return type is a
  # model; plain values otherwise.
  class JsonFakeRepository
    attr_reader :indexes, :statistics

    def initialize(indexes, statistics)
      @indexes = indexes
      @statistics = statistics
    end

    def list_packages(*_args, **_kwargs)
      []
    end

    def all_diagrams
      []
    end

    def supertype_of(*_args, **_kwargs)
      nil
    end
  end

  let(:repository) { JsonFakeRepository.new(indexes, statistics) }

  let(:indexes) do
    {
      classes: { "class1" => uml_class },
      class_to_qname: { "class1" => "ModelRoot::i-UR::urf::Building" },
      associations: {},
      package_to_path: {},
    }
  end

  let(:statistics) do
    {
      total_packages: 3,
      total_classes: 10,
      total_associations: 5,
      total_diagrams: 2,
    }
  end

  let(:exporter) { described_class.new(repository) }
  let(:temp_file) { Tempfile.new(["test", ".json"]) }
  let(:output_path) { temp_file.path }

  after do
    temp_file.close
    temp_file.unlink
  end

  describe "#export" do
    it "exports repository to JSON", :aggregate_failures do
      exporter.export(output_path)

      data = JSON.parse(File.read(output_path))
      expect(data).to have_key("metadata")
      expect(data).to have_key("packages")
      expect(data).to have_key("classes")
      expect(data).to have_key("associations")
    end

    it "includes metadata", :aggregate_failures do
      exporter.export(output_path)

      data = JSON.parse(File.read(output_path))
      expect(data["metadata"]["total_classes"]).to eq(10)
      expect(data["metadata"]["total_packages"]).to eq(3)
    end

    it "exports classes with details", :aggregate_failures do
      exporter.export(output_path)

      data = JSON.parse(File.read(output_path))
      expect(data["classes"]).to be_an(Array)
      expect(data["classes"].first["name"]).to eq("Building")
      expect(data["classes"].first["qualified_name"])
        .to eq("ModelRoot::i-UR::urf::Building")
    end

    it "supports pretty printing", :aggregate_failures do
      exporter.export(output_path, pretty: true)

      content = File.read(output_path)
      expect(content).to include("\n")
      expect(content.lines.count).to be > 10
    end
  end
end
