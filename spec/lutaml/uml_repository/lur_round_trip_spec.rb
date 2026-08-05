# frozen_string true

require "spec_helper"
require "lutaml/uml_repository"
require "lutaml/uml_repository/package_exporter"
require "lutaml/uml_repository/package_loader"
require "tmpdir"

RSpec.describe "LUR programmatic round-trip" do
  # Build a Document programmatically, wrap it in a Repository,
  # export to a real .lur file via PackageExporter, then load it
  # back via PackageLoader. The prior round-trip spec only
  # reloaded a pre-built fixture, which could not catch
  # regressions in PackageExporter's serialization of fresh model
  # instances.
  let(:document) do
    doc = Lutaml::Uml::Document.new
    doc.name = "RoundTripModel"

    root = Lutaml::Uml::Package.new(name: "Root", xmi_id: "rt_root")
    doc.packages << root

    parent = Lutaml::Uml::UmlClass.new(
      name: "Animal",
      xmi_id: "rt_animal",
      stereotype: ["entity"],
    )
    child = Lutaml::Uml::UmlClass.new(
      name: "Dog",
      xmi_id: "rt_dog",
      stereotype: ["entity"],
    )
    generalization = Lutaml::Uml::Generalization.new(name: "Animal")
    child.generalization = generalization

    root.classes << parent
    root.classes << child

    attr = Lutaml::Uml::TopElementAttribute.new(
      name: "name",
      type: "String",
    )
    parent.attributes << attr

    doc
  end

  let(:repository) do
    Lutaml::UmlRepository::Repository.new(document: document)
  end

  let(:temp_dir) { Dir.mktmpdir }
  let(:lur_path) { File.join(temp_dir, "round_trip.lur") }

  after do
    FileUtils.remove_entry(temp_dir) if File.directory?(temp_dir)
  end

  it "exports a fresh Document to .lur and loads it back structurally identical" do
    Lutaml::UmlRepository::PackageExporter.new(repository).export(lur_path)
    expect(File.exist?(lur_path)).to be true

    reloaded = Lutaml::UmlRepository::PackageLoader.load(lur_path)
    expect(reloaded).to be_a(Lutaml::UmlRepository::Repository)

    reloaded_doc = reloaded.document
    expect(reloaded_doc.name).to eq("RoundTripModel")

    root = reloaded_doc.packages.first
    expect(root.name).to eq("Root")

    class_names = root.classes.map(&:name).sort
    expect(class_names).to eq(%w[Animal Dog])
  end

  it "preserves attribute count through round-trip" do
    Lutaml::UmlRepository::PackageExporter.new(repository).export(lur_path)
    reloaded = Lutaml::UmlRepository::PackageLoader.load(lur_path)

    animal = reloaded.document.packages.first.classes.find { |c| c.name == "Animal" }
    expect(animal.attributes.length).to eq(1)
    expect(animal.attributes.first.name).to eq("name")
  end
end
