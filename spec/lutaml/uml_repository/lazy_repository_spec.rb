# frozen_string_literal: true

require "spec_helper"
require "lutaml/uml_repository/lazy_repository"
require "lutaml/uml_repository/repository"

RSpec.describe Lutaml::UmlRepository::LazyRepository do
  # Programmatic fixture (added during TODO.refactor/17) with a
  # parent/child generalization — exercises qualified_names,
  # stereotypes, and inheritance_graph with real data.
  let(:document) { create_inheritance_test_document }
  let(:repo) { described_class.new(document: document, lazy: true) }

  describe "initialization" do
    it "creates a repository without building indexes", :aggregate_failures do
      expect(repo.pending_indexes).to include(:package_paths, :qualified_names,
                                              :stereotypes, :inheritance_graph,
                                              :diagram_index)
      expect(repo.index_built?(:package_paths)).to be false
      expect(repo.index_built?(:qualified_names)).to be false
    end

    it "does not freeze the repository" do
      expect(repo).not_to be_frozen
    end
  end

  describe "lazy index building" do
    describe "#find_class" do
      it "builds qualified_names index on first call", :aggregate_failures do
        expect(repo.index_built?(:qualified_names)).to be false
        repo.find_class("ModelRoot::RootPackage::BibliographicItem")
        expect(repo.index_built?(:qualified_names)).to be true
      end

      it "does not rebuild index on subsequent calls" do
        repo.find_class("ModelRoot::RootPackage::BibliographicItem")
        initial_index = repo.indexes[:qualified_names]
        repo.find_class("ModelRoot::RootPackage::BibliographicItem")
        expect(repo.indexes[:qualified_names]).to equal(initial_index)
      end

      it "removes qualified_names from pending indexes" do
        repo.find_class("ModelRoot::RootPackage::BibliographicItem")
        expect(repo.pending_indexes).not_to include(:qualified_names)
      end
    end

    describe "#find_package" do
      it "builds package_paths index on first call", :aggregate_failures do
        expect(repo.index_built?(:package_paths)).to be false
        repo.find_package("ModelRoot::RootPackage")
        expect(repo.index_built?(:package_paths)).to be true
      end

      it "removes package_paths from pending indexes" do
        repo.find_package("ModelRoot::RootPackage")
        expect(repo.pending_indexes).not_to include(:package_paths)
      end
    end

    describe "#find_classes_by_stereotype" do
      it "builds stereotypes index on first call", :aggregate_failures do
        expect(repo.index_built?(:stereotypes)).to be false
        repo.find_classes_by_stereotype("featureType")
        expect(repo.index_built?(:stereotypes)).to be true
      end

      it "removes stereotypes from pending indexes" do
        repo.find_classes_by_stereotype("featureType")
        expect(repo.pending_indexes).not_to include(:stereotypes)
      end
    end

    describe "#supertype_of" do
      it "builds qualified_names and inheritance_graph indexes",
         :aggregate_failures do
        expect(repo.index_built?(:qualified_names)).to be false
        expect(repo.index_built?(:inheritance_graph)).to be false

        # Triggers index building even when the class is not found
        repo.supertype_of("NonExistentClass")

        expect(repo.index_built?(:qualified_names)).to be true
        expect(repo.index_built?(:inheritance_graph)).to be true
      end

      it "removes both indexes from pending list" do
        repo.supertype_of("SomeClass")
        expect(repo.pending_indexes).not_to include(:qualified_names,
                                                    :inheritance_graph)
      end
    end

    describe "#subtypes_of" do
      it "builds inheritance_graph index on first call", :aggregate_failures do
        expect(repo.index_built?(:inheritance_graph)).to be false
        repo.subtypes_of("BibliographicItem")
        expect(repo.index_built?(:inheritance_graph)).to be true
      end
    end

    describe "#ancestors_of" do
      it "builds qualified_names and inheritance_graph indexes",
         :aggregate_failures do
        expect(repo.index_built?(:qualified_names)).to be false
        expect(repo.index_built?(:inheritance_graph)).to be false

        repo.ancestors_of("Book")

        expect(repo.index_built?(:qualified_names)).to be true
        expect(repo.index_built?(:inheritance_graph)).to be true
      end
    end

    describe "#descendants_of" do
      it "builds inheritance_graph index on first call", :aggregate_failures do
        expect(repo.index_built?(:inheritance_graph)).to be false
        repo.descendants_of("BibliographicItem")
        expect(repo.index_built?(:inheritance_graph)).to be true
      end
    end

    describe "#diagrams_in_package" do
      it "builds diagram_index on first call", :aggregate_failures do
        expect(repo.index_built?(:diagram_index)).to be false
        repo.diagrams_in_package("ModelRoot::RootPackage")
        expect(repo.index_built?(:diagram_index)).to be true
      end

      it "removes diagram_index from pending indexes" do
        repo.diagrams_in_package("ModelRoot::RootPackage")
        expect(repo.pending_indexes).not_to include(:diagram_index)
      end
    end
  end

  describe "#build_all_indexes" do
    it "builds all remaining indexes", :aggregate_failures do
      expect(repo.pending_indexes.size).to be > 0

      repo.build_all_indexes

      expect(repo.index_built?(:package_paths)).to be true
      expect(repo.index_built?(:qualified_names)).to be true
      expect(repo.index_built?(:stereotypes)).to be true
      expect(repo.index_built?(:inheritance_graph)).to be true
      expect(repo.index_built?(:diagram_index)).to be true
    end

    it "clears pending indexes list" do
      repo.build_all_indexes
      expect(repo.pending_indexes).to be_empty
    end

    it "returns self for method chaining" do
      result = repo.build_all_indexes
      expect(result).to eq(repo)
    end

    it "is idempotent" do
      repo.build_all_indexes
      first_indexes = repo.indexes.dup

      repo.build_all_indexes
      second_indexes = repo.indexes

      expect(first_indexes.keys).to match_array(second_indexes.keys)
    end
  end

  describe "#index_built?" do
    it "returns false for unbuilt indexes", :aggregate_failures do
      expect(repo.index_built?(:package_paths)).to be false
      expect(repo.index_built?(:qualified_names)).to be false
    end

    it "returns true for built indexes" do
      repo.find_class("ModelRoot::RootPackage::Book")
      expect(repo.index_built?(:qualified_names)).to be true
    end

    it "handles unknown index names gracefully" do
      expect(repo.index_built?(:unknown_index)).to be false
    end
  end

  describe "#pending_indexes" do
    it "returns array of pending index names", :aggregate_failures do
      pending = repo.pending_indexes
      expect(pending).to be_an(Array)
      expect(pending).to include(:package_paths, :qualified_names)
    end

    it "updates as indexes are built" do
      initial_count = repo.pending_indexes.size
      repo.find_class("ModelRoot::RootPackage::Book")
      expect(repo.pending_indexes.size).to be < initial_count
    end

    it "returns empty array when all indexes are built" do
      repo.build_all_indexes
      expect(repo.pending_indexes).to be_empty
    end
  end

  describe "functional equivalence to Repository" do
    let(:normal_repo) { Lutaml::UmlRepository::Repository.new(document: document) }

    it "provides same find_class results", :aggregate_failures do
      lazy_repo = described_class.new(document: document, lazy: true)
      lazy_repo.build_all_indexes

      normal_result = normal_repo.find_class("ModelRoot::RootPackage::BibliographicItem")
      lazy_result = lazy_repo.find_class("ModelRoot::RootPackage::BibliographicItem")

      expect(lazy_result).not_to be_nil
      expect(normal_result).not_to be_nil
      expect(lazy_result.name).to eq(normal_result.name)
      expect(lazy_result.xmi_id).to eq(normal_result.xmi_id)
    end

    it "provides same find_package results", :aggregate_failures do
      lazy_repo = described_class.new(document: document, lazy: true)
      lazy_repo.build_all_indexes

      normal_result = normal_repo.find_package("ModelRoot::RootPackage")
      lazy_result = lazy_repo.find_package("ModelRoot::RootPackage")

      expect(lazy_result).not_to be_nil
      expect(normal_result).not_to be_nil
    end
  end

  describe "index dependencies" do
    it "builds qualified_names before inheritance_graph", :aggregate_failures do
      expect(repo.index_built?(:qualified_names)).to be false
      expect(repo.index_built?(:inheritance_graph)).to be false

      repo.subtypes_of("BibliographicItem")

      # inheritance_graph requires qualified_names, so both get built
      expect(repo.index_built?(:qualified_names)).to be true
      expect(repo.index_built?(:inheritance_graph)).to be true
    end

    it "builds package_paths before diagram_index", :aggregate_failures do
      expect(repo.index_built?(:package_paths)).to be false
      expect(repo.index_built?(:diagram_index)).to be false

      repo.diagrams_in_package("ModelRoot::RootPackage")

      # diagram_index requires package_paths, so both get built
      expect(repo.index_built?(:package_paths)).to be true
      expect(repo.index_built?(:diagram_index)).to be true
    end
  end

  describe "memory characteristics" do
    it "holds no built indexes before first query" do
      lazy_repo = described_class.new(document: document, lazy: true)
      expect(lazy_repo.indexes.values.compact.size).to eq(0)
    end
  end
end
