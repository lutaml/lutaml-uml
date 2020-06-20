# frozen_string_literal: true

require 'parslet'
require 'lutaml/uml/node/document'

module Lutaml
  module Uml
    module Parsers
      class Dsl < Parslet::Parser
        def self.parse(io, options = {})
          new.parse(io, options)
        end

        def parse(io, options = {})
          Node::Document.new(super)
        end

        KEYWORDS = %w[
          class
          interface
          abstract static
          public protected private
          field method
          generalizes realizes
          directional bidirectional
          dependency association aggregation composition
        ].freeze

        KEYWORDS.each do |keyword|
          rule("kw_#{keyword}") { str(keyword) }
        end

        rule(:newlines)    { (match("\n") | str(';')).repeat(1) } # TODO: Unused
        rule(:newlines?)   { newlines.maybe } # TODO: Unused
        rule(:spaces)      { match("\s").repeat(1) }
        rule(:spaces?)     { spaces.maybe }
        rule(:whitespace)  { (match("\s") | match("\n") | str(';')).repeat(1) }
        rule(:whitespace?) { whitespace.maybe }

        rule(:name) { match['a-zA-Z0-9_-'].repeat(1) }

        rule(:class_name_chars) { match('(?:[a-zA-Z0-9_-]|\:|\.)').repeat(1) }
        rule(:class_name) { class_name_chars >> (str('(') >> class_name_chars >> str(')')).maybe }

        # -- Field/Method

        rule(:kw_access_modifier) { kw_public | kw_protected | kw_private }

        rule(:member_static) { (kw_static.as(:static) >> spaces).maybe }
        rule(:member_access) { (kw_access_modifier.as(:access) >> spaces).maybe }

        rule(:method_abstract) { (kw_abstract.as(:abstract) >> spaces).maybe }
        rule(:member_type)     { (spaces >> str(':') >> spaces >> class_name.as(:type)).maybe }

        rule(:field_keyword)     { kw_field >> spaces }
        rule(:field_name)        { name.as(:name) }
        rule(:field_return_type) { member_type.maybe }
        rule(:field_definition)  { (member_static >> member_access >> field_keyword >> field_name >> field_return_type).as(:field) }

        rule(:method_keyword)         { kw_method >> spaces }
        rule(:method_argument)        { name.as(:name) >> member_type }
        rule(:method_arguments_inner) { (method_argument >> (spaces? >> str(',') >> spaces? >> method_argument).repeat).repeat.as(:arguments) }
        rule(:method_arguments)       { (str('(') >> spaces? >> method_arguments_inner >> spaces? >> str(')')).maybe }

        rule(:method_name)        { name.as(:name) }
        rule(:method_return_type) { member_type.maybe }
        rule(:method_definition)  { (method_abstract >> member_static >> member_access >> method_keyword >> method_name >> method_arguments >> method_return_type).as(:method) }

        # -- Class Relationship

        rule(:kw_class_relationship_type) { kw_generalizes | kw_realizes }

        rule(:class_relationship_type)       { kw_class_relationship_type.as(:type) >> spaces }
        rule(:class_relationship_definition) { (class_relationship_type >> class_name.as(:name)).as(:class_relationship) }

        # -- Relationship

        rule(:kw_relationship_directionality) { kw_directional | kw_bidirectional }
        rule(:kw_relationship_type)           { kw_dependency | kw_association | kw_aggregation | kw_composition }

        rule(:relationship_directionality) { (kw_relationship_directionality.as(:directionality) >> spaces).maybe }
        rule(:relationship_type)           { kw_relationship_type.as(:type) >> spaces }
        rule(:relationship_from)           { (spaces >> (name | str('*').repeat(1)).as(:from)).maybe }
        rule(:relationship_to)             { (spaces >> (name | str('*').repeat(1)).as(:to)).maybe }
        rule(:relationship_definition)     { (relationship_directionality >> relationship_type >> class_name.as(:name) >> relationship_from >> relationship_to).as(:relationship) }

        # -- Class

        rule(:kw_class_modifier) { kw_abstract | kw_interface }

        rule(:class_modifier)          { (kw_class_modifier.as(:modifier) >> spaces).maybe }
        rule(:class_keyword)           { kw_class >> spaces }
        rule(:class_inner_definitions) { field_definition | method_definition | class_relationship_definition | relationship_definition }
        rule(:class_inner_definition)  { class_inner_definitions >> whitespace? }
        rule(:class_body)              { spaces? >> str('{') >> whitespace? >> class_inner_definition.repeat.as(:members) >> str('}') }
        rule(:class_body?)             { class_body.maybe }

        rule(:class_definition) { class_modifier >> class_keyword >> class_name.as(:name) >> class_body? }

        # -- Document

        rule(:document_definitions) { class_definition >> whitespace? }

        rule(:document) { whitespace? >> document_definitions.repeat.as(:classes) }

        # -- Root

        root(:document)
      end
    end
  end
end
