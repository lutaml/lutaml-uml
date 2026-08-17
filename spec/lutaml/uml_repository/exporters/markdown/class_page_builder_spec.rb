# frozen_string_literal: true

require "spec_helper"
require "lutaml/uml_repository/exporters/markdown/class_page_builder"
require "lutaml/uml_repository/exporters/markdown/link_resolver"

RSpec.describe Lutaml::UmlRepository::Exporters::Markdown::ClassPageBuilder do
  # Real model instances + the real LinkResolver over a hand-built
  # index hash — no doubles.
  let(:uml_class) do
    Lutaml::Uml::UmlClass.new(
      name: "Building",
      xmi_id: "class-1",
      stereotype: ["featureType"],
      definition: "A physical structure.",
    )
  end

  let(:indexes) do
    {
      Lutaml::UmlRepository::IndexKeys::CLASS_TO_QNAME => {
        "class-1" => "ModelRoot::urf::Building",
      },
      Lutaml::UmlRepository::IndexKeys::PACKAGE_TO_PATH => {
        "pkg-1" => "ModelRoot::urf",
      },
    }
  end

  let(:link_resolver) do
    Lutaml::UmlRepository::Exporters::Markdown::LinkResolver.new(indexes)
  end

  # Struct stands in for the repository — the builder only reads
  # associations via the link resolver; it never queries the repo
  # directly for class pages.
  StubRepository = Struct.new(:marker)
  let(:builder) { described_class.new(StubRepository.new, link_resolver) }

  let(:markdown) { builder.build(uml_class, "ModelRoot::urf::Building") }

  it "renders a heading with the element type and name" do
    expect(markdown).to start_with("# UmlClass: Building")
  end

  it "renders the qualified name" do
    expect(markdown).to include("**Qualified Name**: `ModelRoot::urf::Building`")
  end

  it "renders a package link derived from the qualified name" do
    expect(markdown).to include("**Package**: [ModelRoot::urf](")
  end

  it "renders the stereotype" do
    expect(markdown).to include("`featureType`")
  end

  it "renders the definition section" do
    expect(markdown).to include("## Description")
    expect(markdown).to include("A physical structure.")
  end

  it "ends with a navigation block" do
    expect(markdown).to include("---")
  end
end
