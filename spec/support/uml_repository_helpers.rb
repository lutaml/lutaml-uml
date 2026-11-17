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

  # A deterministic multi-package document covering every type-resolution
  # branch: same-package, already-qualified, cross-package (unique simple name),
  # same-package-wins-over-ambiguity, ambiguous, primitive and unresolved.
  # Every class carries an xmi_id (the SPA serializers require it).
  def create_resolution_test_document # rubocop:disable Metrics/AbcSize,Metrics/MethodLength
    mk_attr = lambda do |name, type|
      Lutaml::Uml::TopElementAttribute.new(name: name, type: type)
    end
    mk_class = lambda do |name, xmi_id, attrs = []|
      klass = Lutaml::Uml::UmlClass.new(name: name, xmi_id: xmi_id)
      klass.attributes = attrs if attrs.any?
      klass
    end

    # Branches each attribute exercises:
    #   refSame -> same-package (PkgA::Beta); refQualified -> already-qualified;
    #   refCross -> unique simple name (PkgB::Gamma); refSamePkgShared ->
    #   same-package wins over ambiguity; refPrimitive -> primitive;
    #   refUnresolved -> unresolved.
    alpha = mk_class.call("Alpha", "cls_alpha", [
                            mk_attr.call("refSame", "Beta"),
                            mk_attr.call("refQualified", "ModelRoot::PkgB::Gamma"),
                            mk_attr.call("refCross", "Gamma"),
                            mk_attr.call("refSamePkgShared", "Shared"),
                            mk_attr.call("refPrimitive", "String"),
                            mk_attr.call("refUnresolved", "DoesNotExist"),
                          ])
    echo = mk_class.call("Echo", "cls_echo",
                         [mk_attr.call("refAmbiguous", "Shared")]) # from PkgC (no local Shared) => ambiguous

    pkg_a = Lutaml::Uml::Package.new(name: "PkgA", xmi_id: "pkg_a")
    pkg_a.classes = [alpha, mk_class.call("Beta", "cls_beta"),
                     mk_class.call("Shared", "cls_shared_a")]
    pkg_b = Lutaml::Uml::Package.new(name: "PkgB", xmi_id: "pkg_b")
    pkg_b.classes = [mk_class.call("Gamma", "cls_gamma"),
                     mk_class.call("Shared", "cls_shared_b")]
    pkg_c = Lutaml::Uml::Package.new(name: "PkgC", xmi_id: "pkg_c")
    pkg_c.classes = [echo]

    doc = Lutaml::Uml::Document.new(name: "ResolveModel")
    doc.packages = [pkg_a, pkg_b, pkg_c]
    doc
  end
end

RSpec.configure do |config|
  config.include UmlRepositoryHelpers
end
