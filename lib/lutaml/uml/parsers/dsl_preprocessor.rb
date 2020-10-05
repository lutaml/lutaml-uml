# frozen_string_literal: true

module Lutaml
  module Uml
    module Parsers
      # Class for preprocessing dsl ascii file special directives:
      # - include
      module DslPreprocessor
        module_function

        def call(input_file)
          include_root = File.dirname(input_file.path)
          input_file.read.split("\n").reduce([]) do |res, line|
            if include_path_match = line.match(/\s*include\s+(.+)/)
              path_to_file = include_path_match[1].strip
              path_to_file = path_to_file.match?(/^\//) ? path_to_file : File.join(include_root, path_to_file)
              res.push(*File.read(path_to_file).split("\n"))
            else
              res.push(line)
            end
          end.join("\n")
        end
      end
    end
  end
end
