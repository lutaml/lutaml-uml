# frozen_string_literal: true

require "thor"
require "lutaml/uml"
require "lutaml/uml_repository"
require "lutaml/converter"

module Lutaml
  module Cli
    autoload :OutputFormatter, "lutaml/cli/output_formatter"
    autoload :EnhancedFormatter, "lutaml/cli/enhanced_formatter"
    autoload :ResourceRegistry, "lutaml/cli/resource_registry"
    autoload :ElementIdentifier, "lutaml/cli/element_identifier"
    autoload :InteractiveShell, "lutaml/cli/interactive_shell"
    autoload :TreeViewFormatter, "lutaml/cli/tree_view_formatter"
    autoload :UmlCommands, "lutaml/cli/uml_commands"
    autoload :Uml, "lutaml/cli/uml"
  end
end

module Lutaml
  class CLI < Thor
    desc "uml SUBCOMMAND", "UML repository operations (XMI/QEA/LUR files)"
    long_desc <<-DESC
      Perform operations on UML repositories from XMI, QEA, or LUR files.

      Available subcommands:
        build     - Build LUR package from XMI or QEA
        validate  - Validate QEA or LUR file
        info      - Show package metadata
        ls        - List elements
        inspect   - Show element details
        tree      - Package hierarchy
        stats     - Statistics
        search    - Full-text search
        find      - Criteria search
        export    - Export data
        docs      - Generate documentation
        serve     - Web UI
        repl      - Interactive shell
        verify    - XMI/QEA equivalence

      Examples:
        lutaml uml build model.qea
        lutaml uml validate model.lur
        lutaml uml ls model.lur
    DESC
    subcommand "uml", Cli::UmlCommands

    desc "xmi SUBCOMMAND", "UML repository operations (deprecated, use 'uml')"
    long_desc <<-DESC
      DEPRECATED: This is an alias for 'uml' and will be removed in a future version.
      Please use 'lutaml uml' instead.
    DESC
    subcommand "xmi", Cli::UmlCommands

    def self.exit_on_failure?
      true
    end
  end
end
