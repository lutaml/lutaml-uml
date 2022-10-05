# frozen_string_literal: true

module Lutaml
  module Uml
    module Parsers
      # Class for preprocessing dsl ascii file special directives:
      # - include
      class DslPreprocessor
        attr_reader :input_file

        def initialize(input_file)
          @input_file = input_file
        end

        class << self
          def call(input_file)
            new(input_file).call
          end
        end

        def call
          include_root = File.dirname(input_file.path)
          input_file.read.split("\n").reduce([]) do |res, line|
            res.push(*process_dsl_line(include_root, line))
          end.join("\n")
        end

        private

        def process_dsl_line(include_root, line)
          process_include_line(include_root, process_comment_line(line))
        end

        def process_comment_line(line)
          has_comment = line.match(Regexp.new("//(.)*"))
          return line if has_comment.nil?

          line.gsub(Regexp.new("//(.)*"), "")
        end

        def process_include_line(include_root, line)
          include_path_match = line.match(/^\s*include\s+(.+)/)
          return line if include_path_match.nil? || line =~ /^\s\*\*/

          path_to_file = include_path_match[1].strip
          path_to_file = if path_to_file.match?(/^\//)
                           path_to_file
                         else
                           File.join(include_root, path_to_file)
                         end
          File.read(path_to_file).split("\n").map { |line| process_comment_line(line) }
        rescue Errno::ENOENT
          puts("No such file or directory @ rb_sysopen - #{path_to_file}, \
            include file paths need to be supplied relative to the main document")
        end
      end
    end
  end
end
