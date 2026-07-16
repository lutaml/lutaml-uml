# frozen_string_literal: true

require "spec_helper"
require_relative "../../../../lib/lutaml/uml_repository/exporters/" \
                 "markdown_exporter"
require "tempfile"
require "fileutils"

RSpec.describe Lutaml::UmlRepository::Exporters::MarkdownExporter do
  # Real model instances — exercises the actual attribute readers
  # the exporter calls. No doubles.
  let(:uml_class) do
    Lutaml::Uml::UmlClass.new(
      xmi_id: "class1",
      name: "Building",
      stereotype: ["featureType"],
      definition: "A building structure",
    )
  end

  let(:mock_package) do
    Lutaml::Uml::Package.new(
      xmi_id: "pkg1",
      name: "urf",
      definition: "Urban features package",
    )
  end

  # Minimal fake repository exposing the methods MarkdownExporter
  # calls. Real model instances where the return type is a model.
  class MarkdownFakeRepository
    attr_reader :indexes, :statistics

    def initialize(indexes, statistics, package_tree, packages, classes)
      @indexes = indexes
      @statistics = statistics
      @package_tree = package_tree
      @packages = packages
      @classes = classes
    end

    def package_tree(*_args, **_kwargs)
      @package_tree
    end

    def list_packages(*_args, **_kwargs)
      @packages
    end

    def classes_in_package(*_args, **_kwargs)
      @classes
    end

    def diagrams_in_package(*_args, **_kwargs)
      []
    end

    def associations_of(*_args, **_kwargs)
      []
    end

    def supertype_of(*_args, **_kwargs)
      nil
    end

    def subtypes_of(*_args, **_kwargs)
      []
    end
  end

  let(:repository) do
    MarkdownFakeRepository.new(indexes, statistics, tree, [mock_package], [uml_class])
  end
  let(:exporter) { described_class.new(repository) }
  let(:temp_dir) { Dir.mktmpdir }

  let(:indexes) do
    {
      classes: { "class1" => uml_class },
      class_to_qname: { "class1" => "ModelRoot::i-UR::urf::Building" },
      package_to_path: { "pkg1" => "ModelRoot::i-UR::urf" },
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

  let(:tree) do
    {
      name: "ModelRoot",
      path: "ModelRoot",
      classes_count: 0,
      children: [],
    }
  end

  after do
    FileUtils.rm_rf(temp_dir)
  end

  describe "#export" do
    it "creates the directory structure", :aggregate_failures do
      exporter.export(temp_dir)

      expect(File.directory?(temp_dir)).to be true
      expect(File.directory?(File.join(temp_dir, "packages"))).to be true
      expect(File.directory?(File.join(temp_dir, "classes"))).to be true
    end

    it "generates index page", :aggregate_failures do
      exporter.export(temp_dir)

      index_path = File.join(temp_dir, "index.md")
      expect(File.exist?(index_path)).to be true

      content = File.read(index_path)
      expect(content).to include("# UML Model Documentation")
      expect(content).to include("## Statistics")
    end

    it "generates package pages" do
      exporter.export(temp_dir)

      packages_dir = File.join(temp_dir, "packages")
      expect(Dir.empty?(packages_dir)).to be false
    end

    it "generates class pages" do
      exporter.export(temp_dir)

      classes_dir = File.join(temp_dir, "classes")
      expect(Dir.empty?(classes_dir)).to be false
    end

    it "uses custom title when provided" do
      exporter.export(temp_dir, title: "My Custom Title")

      index_path = File.join(temp_dir, "index.md")
      content = File.read(index_path)
      expect(content).to include("# My Custom Title")
    end
  end
end
