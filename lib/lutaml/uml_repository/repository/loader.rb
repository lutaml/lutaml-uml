# frozen_string_string: true

module Lutaml
  module UmlRepository
    class Repository
      # Handles loading Repository instances from various file formats.
      #
      # Encapsulates all file I/O and format detection logic, keeping the
      # main Repository class focused on querying. Delegates to the loader
      # registry (Repository.resolve_document) for format-specific parsing,
      # avoiding hard-coded cross-requires on any specific parser gem.
      #
      # @example Load from any registered format
      #   repo = Loader.from_file('model.xmi')
      #
      # @example Load from LUR package
      #   repo = Loader.from_package('model.lur')
      module Loader
        # Build a Repository from any registered file format.
        #
        # @param xmi_path [String] Path to the file
        # @param options [Hash] Options for parsing
        # @return [Repository]
        def self.from_xmi(xmi_path, options = {})
          Repository.from_file(xmi_path, options)
        end

        # Build a Repository from a file with lazy index loading.
        #
        # @param xmi_path [String] Path to the file
        # @param options [Hash] Options for parsing
        # @return [LazyRepository]
        def self.from_xmi_lazy(xmi_path, _options = {})
          document = Repository.resolve_document(xmi_path)
          LazyRepository.new(document: document, lazy: true)
        end

        # Auto-detect file type and load appropriately.
        #
        # @param path [String] Path to the file (.xmi, .qea, .lur)
        # @return [Repository]
        def self.from_file(path)
          Repository.from_file(path)
        end

        # Smart caching - use LUR if newer than source, otherwise rebuild.
        #
        # @param source_path [String] Path to the source file
        # @param lur_path [String, nil] Path to the LUR package
        # @return [Repository]
        def self.from_file_cached(source_path, lur_path: nil)
          lur_path ||= source_path.sub(/\.[^.]+$/i, ".lur")

          if cache_valid?(lur_path, source_path)
            puts "Using cached LUR package: #{lur_path}" if $VERBOSE
            from_package(lur_path)
          else
            build_and_cache(source_path, lur_path)
          end
        end

        def self.cache_valid?(lur_path, source_path)
          File.exist?(lur_path) && File.mtime(lur_path) >= File.mtime(source_path)
        end

        def self.build_and_cache(source_path, lur_path)
          puts "Building repository from source..." if $VERBOSE
          repo = from_file(source_path)
          puts "Caching as LUR package: #{lur_path}" if $VERBOSE
          repo.export_to_package(lur_path)
          repo
        end

        # Load a Repository from a LUR package file.
        #
        # @param lur_path [String] Path to the .lur package file
        # @return [Repository]
        def self.from_package(lur_path)
          PackageLoader.load(lur_path)
        end

        # Load a Repository from a LUR package with lazy loading.
        #
        # @param lur_path [String] Path to the .lur package file
        # @return [LazyRepository]
        def self.from_package_lazy(lur_path)
          PackageLoader.load_document_only(lur_path)
        end

        # Auto-detect file type with lazy loading.
        #
        # @param path [String] Path to the file
        # @return [LazyRepository]
        def self.from_file_lazy(path)
          case File.extname(path).downcase
          when ".lur" then from_package_lazy(path)
          else from_xmi_lazy(path)
          end
        end
      end
    end
  end
end
