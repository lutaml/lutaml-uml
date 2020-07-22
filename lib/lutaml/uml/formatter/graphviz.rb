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

        VALID_TYPES = %i[
          dot
          xdot
          ps
          pdf
          svg
          svgz
          fig
          png
          gif
          jpg
          jpeg
          json
          imap
          cmapx
        ].freeze

        def initialize(attributes = {})
          super

          @graph = Attributes.new
          @graph['splines'] = 'ortho'
          # TODO: set rankdir
          # @graph['rankdir'] = 'BT'

          @edge = Attributes.new
          @edge['color'] = 'gray50'

          @node = Attributes.new
          @node['shape'] = 'box'

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
          graph_parent_name = generate_graph_name(node.owned_end)
          graph_node_name = generate_graph_name(node.member_end)
          attributes = generate_graph_relationship_attributes(node)
          graph_attributes = " [#{attributes}]" unless attributes.empty?

          %{#{graph_parent_name} -> #{graph_node_name}#{graph_attributes}}
        end

        def generate_graph_relationship_attributes(node)
          attributes = Attributes.new
          if %w[dependency realizes].include?(node.member_end_type)
            attributes['style'] = 'dashed'
          end
          attributes['dir'] = if node.owned_end_type && node.member_end_type
                                'both'
                              elsif node.owned_end_type
                                'back'
                              else
                                'direct'
                              end
          attributes['label'] = node.action if node.action
          if node.owned_end_attribute_name
            attributes['headlabel'] = format_label(
              node.owned_end_attribute_name,
              node.owned_end_cardinality
            )
          end
          if node.member_end_attribute_name
            attributes['taillabel'] = format_label(
              node.member_end_attribute_name,
              node.member_end_cardinality
            )
          end

          attributes['arrowhead'] = case node.owned_end_type
                                    when 'composition'
                                      'diamond'
                                    when 'aggregation'
                                      'odiamond'
                                    else
                                      'onormal'
                                    end

          attributes['arrowtail'] = case node.member_end_type
                                    when 'composition'
                                      'diamond'
                                    when 'aggregation'
                                      'odiamond'
                                    else
                                      'onormal'
                                    end
          # swap labels and arrows if `dir` eq to `back`
          if attributes['dir'] == 'back'
            attributes['arrowhead'], attributes['arrowtail'] = [attributes['arrowtail'], attributes['arrowhead']]
            attributes['headlabel'], attributes['taillabel'] = [attributes['taillabel'], attributes['headlabel']]
          end
          attributes
        end

        def format_label(name, cardinality = {})
          res = "+#{name}"
          if cardinality.nil? ||
             (cardinality['min'].nil? || cardinality['max'].nil?)
            return res
          end

          "#{res} #{cardinality['min']}..#{cardinality['max']}"
        end

        def format_class(node, hide_members)
          name = "<B>#{node.name}</B>"
          name = "«abstract»<BR/><I>#{name}</I>" if node.modifier == 'abstract'
          name = "«interface»<BR/>#{name}" if node.modifier == 'interface'

          unless node.attributes.nil? || node.attributes.empty? || hide_members
            field_rows = node.attributes.map do |field|
              %{<TR><TD ALIGN="LEFT">#{format_field(field)}</TD></TR>}
            end
            field_table = <<~HEREDOC.chomp

                      <TABLE BORDER="0" CELLPADDING="0" CELLSPACING="0">
              #{field_rows.map { |row| ' ' * 10 + row }.join("\n")}
                      </TABLE>
            HEREDOC
            field_table << "\n" << ' ' * 6
          end

          unless node.methods.nil? || node.methods.empty? || hide_members
            method_rows = node.methods.map do |method|
              %{<TR><TD ALIGN="LEFT">#{format_method(method)}</TD></TR>}
            end
            method_table = <<~HEREDOC.chomp

                      <TABLE BORDER="0" CELLPADDING="0" CELLSPACING="0">
              #{method_rows.map { |row| ' ' * 10 + row }.join("\n")}
                      </TABLE>
            HEREDOC
            method_table << "\n" << ' ' * 6
          end

          table_body = [name, field_table, method_table].map do |type|
            next if type.nil?

            <<~TEXT
              <TR>
                <TD>#{type}</TD>
              </TR>
                         TEXT
          end

          <<~HEREDOC.chomp
            <TABLE BORDER="0" CELLBORDER="1" CELLSPACING="0">
              #{table_body.compact.join("\n")}
            </TABLE>
          HEREDOC
        end

        def format_document(node)
          if node.fidelity
            hide_members = node.fidelity['hideMembers']
            hide_other_classes = node.fidelity['hideOtherClasses']
          end
          classes = node.classes.map do |class_node|
            graph_node_name = generate_graph_name(class_node.name)

            <<~HEREDOC
              #{graph_node_name} [shape="plain" label=<
                #{format_class(class_node, hide_members)}
              >]
            HEREDOC
          end.join("\n")
          associations = node.classes.map(&:associations).compact.flatten
          if node.groups
            associations = sort_by_document_groupping(node.groups, associations)
          end
          classes_names = node.classes.map(&:name)
          associations = associations.map do |assoc_node|
            if hide_other_classes &&
               !classes_names.include?(assoc_node.member_end)
              next
            end

            format_relationship(assoc_node)
          end.join("\n")

          classes = classes.lines.map { |line| "  #{line}" }.join.chomp
          associations = associations
                         .lines.map { |line| "  #{line}" }.join.chomp

          <<~HEREDOC
            digraph G {
              graph [#{@graph}]
              edge [#{@edge}]
              node [#{@node}]

            #{classes}

            #{associations}
            }
          HEREDOC
        end

        protected

        def sort_by_document_groupping(groups, associations)
          result = []
          groups.each do |batch|
            batch.each do |group_name|
              associations
                .select { |assc| assc.owned_end == group_name }
                .each do |association|
                  result.push(association) unless result.include?(association)
                end
            end
          end
          associations.each do |association|
            result.push(association) unless result.include?(association)
          end
          result
        end

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
