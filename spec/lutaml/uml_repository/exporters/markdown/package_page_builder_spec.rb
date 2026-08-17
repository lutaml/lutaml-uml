# frozen_string_literal: true

require "spec_helper"
require "lutaml/uml_repository/exporters/markdown/package_page_builder"
require "lutaml/uml_repository/exporters/markdown/link_resolver"

RSpec.describe Lutaml::UmlRepository::Exporters::Markdown::PackagePageBuilder do
  let(:sub_package) { Lutaml::Uml::Package.new(name: "core", xmi_id: "pkg-2") }

  let(:package) do
    pkg = Lutaml::Uml::Package.new(name: "urf", xmi_id: "pkg-1")
    pkg.definition = "Urban features."
    pkg.packages << sub_package
    pkg
  end

  let(:indexes) do
    {
      Lutaml::UmlRepository::IndexKeys::CLASS_TO_QNAME => {},
      Lutaml::UmlRepository::IndexKeys::PACKAGE_TO_PATH => {
        "pkg-1" => "ModelRoot::urf",
        "pkg-2" => "ModelRoot::urf::core",
      },
    }
  end

  let(:link_resolver) do
    Lutaml::UmlRepository::Exporters::Markdown::LinkResolver.new(indexes)
  end

  # The builder queries classes_in_package and diagrams_in_package.
  class StubPkgRepository
    def initialize(classes)
      @classes = classes
    end

    def classes_in_package(*_args, **_kwargs)
      @classes
    end

    def diagrams_in_package(*_args, **_kwargs)
      []
    end
  end

  let(:builder) do
    described_class.new(StubPkgRepository.new([Lutaml::Uml::UmlClass.new(name: "Building")]),
                        link_resolver)
  end

  let(:markdown) { builder.build(package, "ModelRoot::urf") }

  it "renders a heading with the package name" do
    expect(markdown).to start_with("# Package: urf")
  end

  it "renders the qualified path" do
    expect(markdown).to include("**Qualified Path**: `ModelRoot::urf`")
  end

  it "renders the description" do
    expect(markdown).to include("Urban features.")
  end

  it "reports direct class and sub-package counts", :aggregate_failures do
    expect(markdown).to include("**Direct Classes**: 1")
    expect(markdown).to include("**Sub-packages**: 1")
  end

  it "lists the sub-package with a link" do
    expect(markdown).to include("core")
  end

  it "links back to the index" do
    expect(markdown).to include("[Back to Index](../index.md)")
  end
end
