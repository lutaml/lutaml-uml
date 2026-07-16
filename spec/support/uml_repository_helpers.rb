# frozen_string_literal: true

module UmlRepositoryHelpers
  def create_test_document
    create_simple_test_document
  end

  def create_test_repository
    Lutaml::UmlRepository::Repository.new(document: create_test_document)
  end

  # Minimal UML document for query specs that don't need inheritance.
  # One package, one class (TestStereotype), one enum, one nested
  # package. Statistics and shape expectations throughout the spec
  # suite are calibrated to this fixture — change it and the
  # `total_classes: 1` / `TestStereotype: 1` assertions drift.
  def create_simple_test_document # rubocop:disable Metrics/AbcSize
    doc = Lutaml::Uml::Document.new
    doc.name = "TestModel"

    root_package = Lutaml::Uml::Package.new
    root_package.name = "RootPackage"
    root_package.xmi_id = "root_pkg"

    nested_package = Lutaml::Uml::Package.new
    nested_package.name = "NestedPackage"
    nested_package.xmi_id = "nested_pkg"
    root_package.packages << nested_package

    test_class = Lutaml::Uml::UmlClass.new
    test_class.name = "TestClass"
    test_class.xmi_id = "test_class_id"
    test_class.stereotype = "TestStereotype"
    root_package.classes << test_class

    test_enum = Lutaml::Uml::Enum.new
    test_enum.name = "TestEnum"
    test_enum.xmi_id = "test_enum_id"
    root_package.enums << test_enum

    doc.packages << root_package
    doc
  end

  # Document with a parent/child inheritance edge for the
  # inheritance_query specs. Two classes in the same package, one
  # generalizing the other via Generalization#general_id.
  def create_inheritance_test_document # rubocop:disable Metrics/AbcSize
    doc = Lutaml::Uml::Document.new
    doc.name = "InheritanceModel"

    root_package = Lutaml::Uml::Package.new
    root_package.name = "RootPackage"
    root_package.xmi_id = "inh_root_pkg"

    parent = Lutaml::Uml::UmlClass.new
    parent.name = "BibliographicItem"
    parent.xmi_id = "bib_parent"
    parent.stereotype = "featureType"
    root_package.classes << parent

    child = Lutaml::Uml::UmlClass.new
    child.name = "Book"
    child.xmi_id = "bib_child"
    child.stereotype = "featureType"

    generalization = Lutaml::Uml::Generalization.new
    generalization.name = "BibliographicItem"
    child.generalization = generalization
    root_package.classes << child

    doc.packages << root_package
    doc
  end
end

RSpec.configure do |config|
  config.include UmlRepositoryHelpers
end
