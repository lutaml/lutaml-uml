# frozen_string_literal: true

require 'optparse'
require 'pathname'
require 'lutaml/uml/interface/base'
require 'lutaml/uml/parsers/dsl'
require 'lutaml/uml/parsers/yaml'
require 'lutaml/uml/parsers/attribute'
require 'lutaml/uml/formatter'

module Lutaml
  module Uml
    module Interface
      class CommandLine < Base
        class Error < StandardError; end
        class FileError < Error; end

        def initialize(attributes = {})
          @formatter     = Formatter::Graphviz.new
          @verbose       = false
          @option_parser = OptionParser.new

          setup_parser_options

          super
        end

        def output_path=(value)
          @output_path = value.is_a?(Pathname) ? value : Pathname.new(value.to_s) unless value.nil?
        end

        def paths=(values)
          @paths = values.to_a.map { |path| Pathname.new(path) }
        end

        def formatter=(value)
          value = value.to_s.strip.downcase.to_sym
          value = Formatter.find_by(name: value)
          raise Error, "Formatter not found: #{value}" if value.nil?

          @formatter = value
        end

        def run
          args = ARGV.dup # TODO: This is hacky
          begin
            @option_parser.parse!(args)
          rescue StandardError
            nil
          end
          setup_parser_formatter_options
          @option_parser.parse!

          self.paths      = ARGV
          @formatter.type = @type

          raise Error, 'Output path must be a directory if multiple input files are given' if @output_path&.file? && @paths.length > 1

          @paths.each do |input_path|
            raise FileError, "File does not exist: #{input_path}" unless input_path.exist?

            data     = input_path.read
            document = Parsers::Dsl.parse(data)
            result   = @formatter.format(document)

            if @output_path
              output_path = @output_path
              output_path = output_path.join(input_path.basename('.*').to_s + ".#{@formatter.type}") if output_path.directory?

              output_path.open('w+') { |file| file.write(result) }
            else
              puts result
            end
          end
        end

        protected

        def text_bold(body = nil)
          text_effect(1, body)
        end

        def text_italic(body = nil)
          text_effect(3, body)
        end

        def text_bold_italic(body = nil)
          text_bold(text_italic(body))
        end

        def text_underline(body = nil)
          text_effect(4, body)
        end

        def text_effect(num, body = nil)
          result = "\e[#{num}m"
          result << "#{body}#{text_reset}" unless body.nil?

          result
        end

        def text_reset
          "\e[0m"
        end

        def setup_parser_options
          @option_parser.banner = ''
          @option_parser.on('-f', '--formatter VALUE', "The output formatter (Default: '#{@formatter.name}')") { |value| self.formatter = value }
          @option_parser.on('-t', '--type VALUE',      'The output format type') { |value| @type = value }
          @option_parser.on('-o', '--output VALUE',    'The output path') { |value| self.output_path = value }
          @option_parser.on('-h', '--help',            'Prints this help') do
            print_help

            exit
          end
        end

        def setup_parser_formatter_options
          case @formatter.name
          when :graphviz
            @option_parser.on('-g', '--graph VALUE') do |value|
              Parsers::Attribute.parse(value).each { |key, value| @formatter.graph[key] = value }
            end

            @option_parser.on('-e', '--edge VALUE') do |value|
              Parsers::Attribute.parse(value).each { |key, value| @formatter.edge[key] = value }
            end

            @option_parser.on('-n', '--node VALUE') do |value|
              Parsers::Attribute.parse(value).each { |key, value| @formatter.node[key] = value }
            end

            @option_parser.on('-a', '--all VALUE') do |value|
              Parsers::Attribute.parse(value).each do |key, value|
                @formatter.graph[key] = value
                @formatter.edge[key] = value
                @formatter.node[key] = value
              end
            end
          end
        end

        def print_help
          puts <<~HELP
            #{text_bold('Usage:')} ucd [options] PATHS

            #{text_bold('Overview:')} Generate output from UML Class Diagram language files

            #{text_bold('Options:')}
            #{@option_parser}
            #{text_bold('Paths:')}

                UCD can accept multiple paths for parsing for easier batch processing.

                The location of the output by default is standard output.

                The output can be directed to a path with #{text_bold_italic('--output')}, which can be a file or a directory.
                If the output path is a directory, then the filename will be the same as the input filename,
                  with it's file extension substituted with the #{text_bold_italic('--type')}.

                #{text_underline('Examples')}

                    `ucd project.ucd`

                        Produces DOT notation, sent to standard output

                    `ucd -o . project.ucd`

                        Produces DOT notation, written to #{text_italic('./project.dot')}

                    `ucd -o ./diagram.dot project.ucd`

                        Produces DOT notation, written to #{text_italic('./diagram.dot')}

                    `ucd -o ./diagram.png project.ucd`

                        Produces PNG image, written to #{text_italic('./diagram.png')}

                    `ucd -t png -o . project.ucd`

                        Produces PNG image, written to #{text_italic('./project.png')}

                    `ucd -t png -o . project.ucd core_ext.ucd`

                        Produces PNG images, written to #{text_italic('./project.png')} and #{text_italic('./core_ext.png')}

            #{text_bold('Formatters:')}

                #{text_underline('Graphviz')}

                  Generates DOT notation and can use the DOT notation to generate any format Graphviz can produce.

                  The output format is based on #{text_bold_italic('--type')}, which by default is "dot".
                  If #{text_bold_italic('--type')} is not given and #{text_bold_italic('--output')} is, the file extension of the #{text_bold_italic('--output')} path will be used.

                  Valid types/extensions are: #{Formatter::Graphviz::VALID_TYPES.join(', ')}

                  #{text_bold('Options:')}

                      -g, --graph VALUE                The graph attributes
                      -e, --edge VALUE                 The edge attributes
                      -n, --node VALUE                 The node attributes
                      -a, --all VALUE                  Set attributes for graph, edge, and node

          HELP
        end
      end
    end
  end
end
