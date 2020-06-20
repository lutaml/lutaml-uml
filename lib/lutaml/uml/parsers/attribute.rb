# frozen_string_literal: true

require 'parslet'

module Lutaml
  module Uml
    module Parsers
      class Attribute < Parslet::Parser
        class Transform < Parslet::Transform
          rule(integer: simple(:x)) { Integer(x) }
          rule(float: simple(:x)) { Float(x) }
          rule(string: simple(:x)) { String(x) }
        end

        def self.parse(io, options = {})
          new.parse(io, options)
        end

        def parse(io, options = {})
          tree = Transform.new.apply(super)
          tree = tree[:assignments].each_with_object({}) { |assignment, memo| memo[assignment[:name].to_s] = assignment[:value] }

          tree
        end

        rule(:spaces) { match("\s").repeat(1) }
        rule(:spaces?) { spaces.maybe }

        rule(:digits) { match['0-9'].repeat(1) }

        rule(:integer) { (str('-').maybe >> digits >> str('.').absent?).as(:integer) }
        rule(:float) { (str('-').maybe >> digits >> str('.') >> digits).as(:float) }

        rule(:string_single_quoted) { str("'") >> (str("'").absent? >> any).repeat.as(:string) >> str("'") }
        rule(:string_double_quoted) { str('"') >> (str('"').absent? >> any).repeat.as(:string) >> str('"') }

        rule(:string) { string_single_quoted | string_double_quoted }

        rule(:assignment_name) { (match["=\s"].absent? >> any).repeat.as(:name) }
        rule(:assignment_value) { (integer | float | string).as(:value) }
        rule(:assignment) { assignment_name >> spaces? >> str('=') >> spaces? >> assignment_value }

        rule(:attribute) { spaces? >> assignment >> spaces? }
        rule(:attributes) { (attribute >> (str(',') >> attribute).repeat).repeat.as(:assignments) }

        root(:attributes)
      end
    end
  end
end
