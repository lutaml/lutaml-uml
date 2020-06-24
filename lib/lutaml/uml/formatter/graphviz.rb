# frozen_string_literal: true

require 'open3'
require 'lutaml/uml/formatter/base'

module Lutaml
  module Uml
    module Formatter
      class Graphviz < Base
        class Attributes < Hash
          def to_s
            to_a.map { |(a, b)| "#{a}=#{b.inspect}" }.join(' ')
          end
        end

        ACCESS_SYMBOLS = {
          'public'    => '+',
          'protected' => '#',
          'private'   => '-'
        }.freeze

        VALID_TYPES = %i[dot xdot ps pdf svg svgz fig png gif jpg jpeg json imap cmapx].freeze

        def initialize(attributes = {})
          super

          @graph = Attributes.new
          @graph['splines'] = 'ortho'
          @graph['rankdir'] = 'BT'

          @edge = Attributes.new
          @edge['color'] = 'gray50'

          @node = Attributes.new
          @node['shape'] = 'plain'

          @type = :dot
        end

        attr_reader :graph
        attr_reader :edge
        attr_reader :node

        def type=(value)
          super

          @type = :dot unless VALID_TYPES.include?(@type)
        end

        def format(node)
          dot = super.lines.map(&:rstrip).join("\n")

          generate_from_dot(dot)
        end

        def format_field(node)
          symbol = ACCESS_SYMBOLS[node.visibility]
          result = "#{symbol} #{node.name}"
          result += " : #{node.type}" if node.type
          result = "<U>#{result}</U>" if node.static

          result
        end

        def format_method(node)
          symbol = ACCESS_SYMBOLS[node.access]
          result = "#{symbol} #{node.name}"
          if node.arguments
            arguments = node.arguments.map do |argument|
              "#{argument.name}#{" : #{argument.type}" if argument.type}"
            end.join(', ')
          end

          result << "(#{arguments})"
          result << " : #{node.type}" if node.type
          result = "<U>#{result}</U>" if node.static
          result = "<I>#{result}</I>" if node.abstract

          result
        end

        def format_relationship(node)
          dir       = 'back' if %w[aggregation composition].include?(node.type)
          arrow_key = dir == 'back' ? 'arrowtail' : 'arrowhead'
          from_key  = dir == 'back' ? 'taillabel' : 'headlabel'
          to_key    = dir == 'back' ? 'headlabel' : 'taillabel'

          attributes = Attributes.new

          attributes['style']   = 'dashed'  if node.type == 'dependency'
          attributes['dir']     = dir       if dir
          attributes[from_key]  = node.from if node.from
          attributes[to_key]    = node.to   if node.to

          if %w[aggregation composition].include?(node.type)
            arrow     = 'diamond'  if node.type == 'composition'
            arrow     = 'odiamond' if node.type == 'aggregation'
            attributes[arrow_key] = arrow
          end

          graph_parent_name = generate_graph_name(node.parent.name)
          graph_node_name   = generate_graph_name(node.name)
          graph_attributes  = " [#{attributes}]" unless attributes.empty?

          %{Class#{graph_parent_name} -> Class#{graph_node_name}#{graph_attributes}}
        end

        def format_class_relationship(node)
          attributes = Attributes.new

          attributes['arrowhead'] = 'onormal'
          attributes['style'] = 'dashed' if node.type == 'realizes'

          graph_parent_name = generate_graph_name(node.parent.name)
          graph_node_name = generate_graph_name(node.name)

          %{Class#{graph_parent_name} -> Class#{graph_node_name} [#{attributes}]}
        end

        def format_class(node)
          name = "<B>#{node.name}</B>"
          name = "«abstract»<BR/><I>#{name}</I>" if node.modifier == 'abstract'
          name = "«interface»<BR/>#{name}" if node.modifier == 'interface'

          unless node.fields.nil? || node.fields.empty?
            field_rows  = node.fields.map { |field| %{<TR><TD ALIGN="LEFT">#{format_field(field)}</TD></TR>} }
            field_table = <<~HEREDOC.chomp

                      <TABLE BORDER="0" CELLPADDING="0" CELLSPACING="0">
              #{field_rows.map { |row| ' ' * 10 + row }.join("\n")}
                      </TABLE>
  HEREDOC
            field_table << "\n" << ' ' * 6
          end

          unless node.methods.nil? || node.methods.empty?
            method_rows  = node.methods.map { |method| %{<TR><TD ALIGN="LEFT">#{format_method(method)}</TD></TR>} }
            method_table = <<~HEREDOC.chomp

                      <TABLE BORDER="0" CELLPADDING="0" CELLSPACING="0">
              #{method_rows.map { |row| ' ' * 10 + row }.join("\n")}
                      </TABLE>
  HEREDOC
            method_table << "\n" << ' ' * 6
          end

          <<~HEREDOC.chomp
            <TABLE BORDER="0" CELLBORDER="1" CELLSPACING="0">
                <TR>
                  <TD>#{name}</TD>
                </TR>
                <TR>
                  <TD>#{field_table}</TD>
                </TR>
                <TR>
                  <TD>#{method_table}</TD>
                </TR>
              </TABLE>
  HEREDOC
        end

        def format_document(node)
          classes = node.classes.map do |node|
            graph_node_name = generate_graph_name(node.name)

            <<~HEREDOC
              Class#{graph_node_name} [label=<
                #{format_class(node)}
              >]
            HEREDOC
          end.join("\n")
          class_relationships = node.classes.map(&:class_relationships).flatten.map { |node| format_class_relationship(node) }.join("\n")
          relationships = node.classes.map(&:relationships).flatten.map { |node| format_relationship(node) }.join("\n")

          classes = classes.lines.map { |line| "  #{line}" }.join.chomp
          class_relationships = class_relationships.lines.map { |line| "  #{line}" }.join.chomp
          relationships = relationships.lines.map { |line| "  #{line}" }.join.chomp

          <<~HEREDOC
            digraph G {
              graph [#{@graph}]
              edge [#{@edge}]
              node [#{@node}]

            #{classes}

            #{class_relationships}

            #{relationships}
            }
  HEREDOC
        end

        protected

        def generate_from_dot(dot)
          return dot if @type == :dot

          Open3.popen3("dot -T#{type}") do |stdin, stdout, _stderr, _wait|
            stdin.puts(dot)
            stdin.close
            # unless (err = stderr.read).empty? then raise err end
            stdout.read
          end
        end

        def generate_graph_name(name)
          name.gsub(/[^0-9a-zA-Z]/i, '')
        end
      end
    end
  end
end
