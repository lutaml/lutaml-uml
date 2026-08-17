# frozen_string_literal: true

require "spec_helper"
require "lutaml/uml_repository"

RSpec.describe "Repository query-service readers" do
  # ADR-0001 documents repo.class_query / repo.inheritance_query / etc.
  # as the composability seam. These specs pin that contract: each
  # reader must be publicly callable and return the corresponding
  # query service wired to this repository.
  let(:repository) { create_test_repository }

  {
    package_query:     Lutaml::UmlRepository::Queries::PackageQuery,
    class_query:       Lutaml::UmlRepository::Queries::ClassQuery,
    inheritance_query: Lutaml::UmlRepository::Queries::InheritanceQuery,
    association_query: Lutaml::UmlRepository::Queries::AssociationQuery,
    diagram_query:     Lutaml::UmlRepository::Queries::DiagramQuery,
    search_query:      Lutaml::UmlRepository::Queries::SearchQuery,
  }.each do |reader, service_class|
    it "exposes ##{reader} publicly as a #{service_class.name.split('::').last}" do
      expect(repository.public_methods).to include(reader)
      expect(repository.public_send(reader)).to be_a(service_class)
    end
  end

  it "supports composing services without new facade methods" do
    # Example composition: find a class via class_query, then walk its
    # hierarchy via inheritance_query — no facade method for this pair.
    klass = repository.class_query.find_by_qname("ModelRoot::RootPackage::TestClass")
    expect(klass).not_to be_nil

    parent = repository.inheritance_query.find_parent(klass.xmi_id)
    # The simple fixture has no generalization on TestClass — the point
    # is that the composition call itself works through the public seam.
    expect { repository.inheritance_query.find_ancestors(klass.xmi_id) }
      .not_to raise_error
  end
end
