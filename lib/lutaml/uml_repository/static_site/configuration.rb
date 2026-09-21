# frozen_string_literal: true

require "lutaml/model"
require "yaml"

module Lutaml
  module UmlRepository
    module StaticSite
      # Configuration for Static Site Generator using external YAML.
      #
      # Follows the Dependency Inversion Principle by externalizing all
      # configuration instead of hardcoding values. Uses lutaml-model for
      # structured YAML parsing and validation.
      #
      # @example Load configuration
      #   config = Configuration.load
      #
      # @example Load custom configuration
      #   config = Configuration.load("my_config.yml")
      class Configuration < Lutaml::Model::Serializable
        # Output mode configuration
        class OutputMode < Lutaml::Model::Serializable
          attribute :enabled, :boolean, default: -> { true }
          attribute :default_filename, :string
          attribute :default_directory, :string
          attribute :embed_data, :boolean
          attribute :embed_styles, :boolean
          attribute :embed_scripts, :boolean
          attribute :data_directory, :string
          attribute :assets_directory, :string
          attribute :minify, :boolean, default: -> { false }

          yaml do
            map "enabled", to: :enabled
            map "default_filename", to: :default_filename
            map "default_directory", to: :default_directory
            map "embed_data", to: :embed_data
            map "embed_styles", to: :embed_styles
            map "embed_scripts", to: :embed_scripts
            map "data_directory", to: :data_directory
            map "assets_directory", to: :assets_directory
            map "minify", to: :minify
          end
        end

        # Output configuration container
        class OutputConfig < Lutaml::Model::Serializable
          attribute :modes, :string # Will be parsed as hash

          yaml do
            map "modes", to: :modes
          end

          def single_file
            return unless modes

            @single_file ||= begin
              hash = parse_modes_hash
              parse_mode_config(hash["single_file"])
            end
          end

          def multi_file
            return unless modes

            @multi_file ||= begin
              hash = parse_modes_hash
              parse_mode_config(hash["multi_file"])
            end
          end

          private

          def parse_modes_hash
            Configuration.parse_hash_attribute(modes)
          end

          def parse_mode_config(config_hash) # rubocop:disable Metrics/AbcSize,Metrics/MethodLength
            return nil unless config_hash

            OutputMode.new.tap do |mode|
              mode.enabled = config_hash["enabled"]
              mode.default_filename = config_hash["default_filename"]
              mode.default_directory = config_hash["default_directory"]
              mode.embed_data = config_hash["embed_data"]
              mode.embed_styles = config_hash["embed_styles"]
              mode.embed_scripts = config_hash["embed_scripts"]
              mode.data_directory = config_hash["data_directory"]
              mode.assets_directory = config_hash["assets_directory"]
              mode.minify = config_hash["minify"]
            end
          end
        end

        # Search field configuration
        class SearchField < Lutaml::Model::Serializable
          attribute :name, :string
          attribute :boost, :integer, default: -> { 1 }
          attribute :searchable, :boolean, default: -> { true }

          yaml do
            map "name", to: :name
            map "boost", to: :boost
            map "searchable", to: :searchable
          end
        end

        # Document type configuration
        class DocumentType < Lutaml::Model::Serializable
          attribute :type, :string
          attribute :boost, :float, default: -> { 1.0 }
          attribute :enabled, :boolean, default: -> { true }

          yaml do
            map "type", to: :type
            map "boost", to: :boost
            map "enabled", to: :enabled
          end
        end

        # Search configuration
        class SearchConfig < Lutaml::Model::Serializable
          attribute :enabled, :boolean, default: -> { true }
          attribute :fields, SearchField, collection: true
          attribute :document_types, DocumentType, collection: true
          attribute :stop_words, :string, collection: true
          attribute :pipeline, :string, collection: true

          yaml do
            map "enabled", to: :enabled
            map "fields", to: :fields
            map "document_types", to: :document_types
            map "stop_words", to: :stop_words
            map "pipeline", to: :pipeline
          end
        end

        # UI configuration
        class UIConfig < Lutaml::Model::Serializable
          attribute :title, :string
          attribute :description, :string
          attribute :theme, :string # Will be parsed as hash
          attribute :sidebar, :string # Will be parsed as hash
          attribute :breadcrumb, :string  # Will be parsed as hash
          attribute :statistics, :string  # Will be parsed as hash

          yaml do
            map "title", to: :title
            map "description", to: :description
            map "theme", to: :theme
            map "sidebar", to: :sidebar
            map "breadcrumb", to: :breadcrumb
            map "statistics", to: :statistics
          end
        end

        # Logo configuration for light/dark variants
        class LogoVariant < Lutaml::Model::Serializable
          attribute :path, :string
          attribute :url, :string

          yaml do
            map "path", to: :path
            map "url", to: :url
          end
        end

        # Logo configuration (square, long, etc.)
        class LogoConfig < Lutaml::Model::Serializable
          attribute :light, LogoVariant
          attribute :dark, LogoVariant

          yaml do
            map "light", to: :light
            map "dark", to: :dark
          end
        end

        # Logos container
        class LogosConfig < Lutaml::Model::Serializable
          attribute :square, LogoConfig
          attribute :long, LogoConfig

          yaml do
            map "square", to: :square
            map "long", to: :long
          end
        end

        # Appearance configuration
        class AppearanceConfig < Lutaml::Model::Serializable
          attribute :logos, LogosConfig
          attribute :favicon, :string # Will be array of hashes
          attribute :colors, :string # Will be hash
          attribute :typography, :string # Will be hash
          attribute :custom_css, :string
          attribute :layout, :string # Will be hash

          yaml do
            map "logos", to: :logos
            map "favicon", to: :favicon
            map "colors", to: :colors
            map "typography", to: :typography
            map "custom_css", to: :custom_css
            map "layout", to: :layout
          end
        end

        # Author configuration
        class AuthorConfig < Lutaml::Model::Serializable
          attribute :name, :string
          attribute :email, :string

          yaml do
            map "name", to: :name
            map "email", to: :email
          end
        end

        # External link configuration
        class LinkConfig < Lutaml::Model::Serializable
          attribute :name, :string
          attribute :url, :string

          yaml do
            map "name", to: :name
            map "url", to: :url
          end
        end

        # Metadata configuration
        class MetadataConfig < Lutaml::Model::Serializable
          attribute :name, :string
          attribute :title, :string
          attribute :description, :string
          attribute :version, :string
          attribute :license, :string
          attribute :license_url, :string
          attribute :authors, AuthorConfig, collection: true
          attribute :homepage, :string
          attribute :repository, :string
          attribute :documentation, :string
          attribute :tags, :string, collection: true
          attribute :links, LinkConfig, collection: true
          attribute :appearance, AppearanceConfig

          yaml do
            map "name", to: :name
            map "title", to: :title
            map "description", to: :description
            map "version", to: :version
            map "license", to: :license
            map "license_url", to: :license_url
            map "authors", to: :authors
            map "homepage", to: :homepage
            map "repository", to: :repository
            map "documentation", to: :documentation
            map "tags", to: :tags
            map "links", to: :links
            map "appearance", to: :appearance
          end
        end

        # Main configuration attributes
        attribute :version, :string
        attribute :description, :string
        attribute :metadata, MetadataConfig
        attribute :output, OutputConfig
        attribute :templates, :string # Will be hash
        attribute :data_transformation, :string # Will be hash
        attribute :search, SearchConfig
        attribute :assets, :string # Will be hash
        attribute :ui, UIConfig
        attribute :features, :string # Will be hash
        attribute :plugins, :string # Will be hash
        attribute :performance, :string # Will be hash
        attribute :accessibility, :string # Will be hash

        yaml do
          map "version", to: :version
          map "description", to: :description
          map "metadata", to: :metadata
          map "output", to: :output
          map "templates", to: :templates
          map "data_transformation", to: :data_transformation
          map "search", to: :search
          map "assets", to: :assets
          map "ui", to: :ui
          map "features", to: :features
          map "plugins", to: :plugins
          map "performance", to: :performance
          map "accessibility", to: :accessibility
        end

        class << self
          # Load configuration from YAML file
          #
          # @param config_path [String, nil] Path to configuration file
          # @return [Configuration] Loaded configuration
          def load(config_path = nil)
            config_path ||= default_config_path

            unless File.exist?(config_path)
              return create_default_configuration
            end

            yaml_content = File.read(config_path)
            from_yaml(yaml_content)
          end

          # Get default configuration file path
          #
          # @return [String] Path to default config
          def default_config_path
            File.expand_path("../../../../config/static_site.yml", __dir__)
          end

          # Create default configuration programmatically
          #
          # @return [Configuration] Default configuration
          def create_default_configuration
            new.tap do |config|
              config.version = "1.0"
              config.description = "Default Static Site Configuration"
            end
          end
        end

        # Get data transformation options as hash
        #
        # @return [Hash] Transformation options
        def transformation_options
          @transformation_options ||= parse_hash_attribute(data_transformation)
        end

        # Get features as hash
        #
        # @return [Hash] Feature flags
        def feature_flags
          @feature_flags ||= parse_hash_attribute(features)
        end

        # Check if a feature is enabled
        #
        # @param feature_name [String, Symbol] Feature name
        # @return [Boolean] true if feature is enabled
        def feature_enabled?(feature_name)
          flags = feature_flags
          return false if flags.nil? || flags.empty?

          flags[feature_name.to_s] == true
        end

        private

        def parse_hash_attribute(attr)
          self.class.parse_hash_attribute(attr)
        end

        class << self
          # Parse an attribute that may be a Hash, a plain String, or a
          # Lutaml::Model::Type::String wrapping a Ruby-hash-literal
          # representation.  Returns a Hash on success, empty Hash otherwise.
          def parse_hash_attribute(attr) # rubocop:disable Metrics/CyclomaticComplexity,Metrics/MethodLength,Metrics/PerceivedComplexity
            return attr if attr.is_a?(Hash)

            attr_str = attr.to_s
            return {} if attr_str.empty?

            # Try YAML first (handles valid YAML maps).
            begin
              parsed = YAML.safe_load(attr_str, permitted_classes: [Symbol])
              return parsed if parsed.is_a?(Hash)
            rescue StandardError
              # Fall through to Ruby-hash-literal parsing.
            end

            # Fall back for Ruby hash-rocket syntax emitted by lutaml-model
            # when storing nested YAML hashes in a :string attribute.
            return parse_ruby_hash_literal(attr_str) if attr_str.include?("=>")

            {}
          end

          private

          # Parse a restricted subset of the Ruby hash literal: keys/values
          # use Ruby scalar literals (String, Symbol, Integer, Float, true,
          # false, nil). Quotes are honoured; braces are stripped.
          def parse_ruby_hash_literal(attr)
            body = attr.to_s.gsub(/\A\s*\{|\}\s*\z/, "")
            return {} if body.empty?

            parse_hash_body(body)
          end

          # Parse the inner body of a Ruby hash literal (no outer braces).
          # Handles nested hashes by tracking brace depth so commas inside
          # nested `{ ... }` blocks are not treated as pair separators.
          def parse_hash_body(body)
            pairs = split_top_level(body)
            pairs.each_with_object({}) do |pair, hash|
              key, value = pair.split("=>", 2)
              next unless key && value

              key_str = key.strip
              value_str = value.strip

              if value_str.start_with?("{")
                hash[parse_literal(key_str)] = parse_hash_body(
                  value_str.gsub(/\A\s*\{|\}\s*\z/, ""),
                )
              else
                hash[parse_literal(key_str)] = parse_literal(value_str)
              end
            end
          rescue StandardError
            {}
          end

          # Split a hash body on top-level commas, respecting nested braces.
          def split_top_level(body)
            parts = []
            depth = 0
            current = +""

            body.each_char do |ch|
              case ch
              when "{" then depth += 1
              when "}" then depth -= 1
              when ","
                if depth.zero?
                  parts << current
                  current = +""
                  next
                end
              end
              current << ch
            end
            parts << current unless current.empty?
            parts
          end

          # Coerce a token from a Ruby hash literal into its scalar value.
          def parse_literal(token)
            case token
            when /\A".*"\z/  then token[1..-2]
            when /\A'.*'\z/  then token[1..-2]
            when /\A:/       then token[1..].to_sym
            when "true"      then true
            when "false"     then false
            when "nil"       then nil
            when /\A-?\d+\z/ then token.to_i
            when /\A-?\d+\.\d+\z/ then token.to_f
            else token
            end
          end
        end

      end
    end
  end
end
