# frozen_string_literal: true

require "parslet"
require "lutaml/uml/parsers/dsl_transform"
require "lutaml/uml/node/document"

module Lutaml
  module Uml
    module Parsers
      # Class for parsing LutaML dsl into Lutaml::Uml::Document
      class Dsl < Parslet::Parser
        # @param [String] io - LutaML string representation
        #        [Hash] options - options for parsing
        #
        # @return [Lutaml::Uml::Document]
        def self.parse(io, options = {})
          new.parse(io, options)
        end

        def parse(io, options = {})
          ::Lutaml::Uml::Document.new(DslTransform.new.apply(super))
        end

        KEYWORDS = %w[
          diagram
          title
          class
          interface
          abstract static
          public protected private
          attribute method
          generalizes realizes
          directional bidirectional
          dependency association aggregation composition
        ].freeze

        KEYWORDS.each do |keyword|
          rule("kw_#{keyword}") { str(keyword) }
        end

        rule(:spaces) { match("\s").repeat(1) }
        rule(:spaces?) { spaces.maybe }
        rule(:whitespace) { (match("\s") | match("\n") | str(";")).repeat(1) }
        rule(:whitespace?) { whitespace.maybe }

        rule(:name) { match["a-zA-Z0-9_-"].repeat(1) }

        rule(:class_name_chars) { match('(?:[a-zA-Z0-9_-]|\:|\.)').repeat(1) }
        rule(:class_name) do
          class_name_chars >> (str("(") >> class_name_chars >> str(")")).maybe
        end
        rule(:cardinality) do
          spaces >>
            str("[") >>
            (match['0-9\*'].as(:min) >>
              str("..").maybe >>
              match['0-9\*'].as(:max).maybe)
            .as(:cardinality) >>
            str("]")
        end
        rule(:cardinality?) { cardinality.maybe }

        # -- attribute/Method

        rule(:kw_visibility_modifier) do
          str("+") | str("-") | str("#") | str("~")
        end

        rule(:member_static) { (kw_static.as(:static) >> spaces).maybe }
        rule(:visibility) do
          kw_visibility_modifier.as(:visibility_modifier).maybe
        end

        rule(:method_abstract) { (kw_abstract.as(:abstract) >> spaces).maybe }
        rule(:member_type) do
          (str(":") >> spaces >> class_name.as(:type)).maybe
        end

        rule(:attribute_name) { name.as(:name) }
        rule(:attribute_return_type) { member_type.maybe }
        rule(:attribute_definition) do
          (visibility.as(:visibility) >>
            attribute_name >>
            attribute_return_type >>
            cardinality?)
            .as(:attribute)
        end

        rule(:title_keyword) { kw_title >> spaces }
        rule(:title_text) do
          match['"'].maybe >>
            match('[a-zA-Z0-9_-]|\s').repeat(1).as(:title) >>
            match['"'].maybe
        end
        rule(:title_definition) { title_keyword >> title_text }

        rule(:method_keyword) { kw_method >> spaces }
        rule(:method_argument) { name.as(:name) >> member_type }
        rule(:method_arguments_inner) do
          (method_argument >>
            (spaces? >> str(",") >> spaces? >> method_argument).repeat)
            .repeat.as(:arguments)
        end
        rule(:method_arguments) do
          (str("(") >>
            spaces? >>
            method_arguments_inner >>
            spaces? >>
            str(")"))
            .maybe
        end

        rule(:method_name) { name.as(:name) }
        rule(:method_return_type) { member_type.maybe }
        rule(:method_definition) do
          (method_abstract >>
            member_static >>
            visibility >>
            method_keyword >>
            method_name >>
            method_arguments >>
            method_return_type)
            .as(:method)
        end

        # -- Class Relationship

        rule(:kw_class_relationship_type) { kw_generalizes | kw_realizes }

        rule(:class_relationship_type) do
          kw_class_relationship_type.as(:type) >> spaces
        end
        rule(:class_relationship_definition) do
          (class_relationship_type >> class_name.as(:name))
            .as(:class_relationship)
        end

        # -- Relationship

        rule(:kw_relationship_directionality) do
          kw_directional | kw_bidirectional
        end
        rule(:kw_relationship_type) do
          kw_dependency | kw_association | kw_aggregation | kw_composition
        end

        rule(:relationship_directionality) do
          (kw_relationship_directionality.as(:directionality) >> spaces).maybe
        end
        rule(:relationship_type) { kw_relationship_type.as(:type) >> spaces }
        rule(:relationship_from) do
          (spaces >> (name | str("*").repeat(1)).as(:from)).maybe
        end
        rule(:relationship_to) do
          (spaces >> (name | str("*").repeat(1)).as(:to)).maybe
        end
        rule(:relationship_definition) do
          (relationship_directionality >>
            relationship_type >>
            class_name.as(:name) >>
            relationship_from >>
            relationship_to)
            .as(:relationship)
        end

        # -- Class

        rule(:kw_class_modifier) { kw_abstract | kw_interface }

        rule(:class_modifier) do
          (kw_class_modifier.as(:modifier) >> spaces).maybe
        end
        rule(:class_keyword) { kw_class >> spaces }
        rule(:class_inner_definitions) do
          attribute_definition |
            method_definition |
            class_relationship_definition |
            relationship_definition
        end
        rule(:class_inner_definition) do
          class_inner_definitions >> whitespace?
        end
        rule(:class_body) do
          spaces? >>
            str("{") >>
            whitespace? >>
            class_inner_definition.repeat.as(:members) >>
            str("}")
        end
        rule(:class_body?) { class_body.maybe }
        rule(:class_definition) do
          class_modifier >>
            class_keyword >>
            class_name.as(:name) >>
            class_body?
        end

        # -- Diagram

        rule(:diagram_keyword) { kw_diagram >> spaces? }
        rule(:diagram_inner_definitions) do
          title_definition |
            class_definition.as(:class) |
            relationship_definition
        end
        rule(:diagram_inner_definition) do
          diagram_inner_definitions >> whitespace?
        end
        rule(:title_definitions?) do
          (title_definition >> whitespace?).maybe
        end
        rule(:diagram_body) do
          spaces? >>
            str("{") >>
            whitespace? >>
            title_definitions? >>
            diagram_inner_definition.repeat.as(:members) >>
            str("}")
        end
        rule(:diagram_body?) { diagram_body.maybe }
        rule(:diagram_definition) do
          diagram_keyword >>
            spaces? >>
            class_name.as(:name) >>
            diagram_body?
        end
        rule(:diagram_definitions) { diagram_definition >> whitespace? }
        rule(:diagram) { whitespace? >> diagram_definition }
        # -- Root

        root(:diagram)
      end
    end
  end
end
