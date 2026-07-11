# frozen_string_literal: true

module Lutaml
  module Uml
    # Walks a Document or Package tree, yielding elements of each declared
    # collection type together with their containing package path.
    #
    # Walk target must be a {Document} or {Package}. The +types+ argument
    # declares which collection readers to visit; only known readers are
    # dispatched so the walk is type-safe.
    class PackageWalker
      # Reader method names that may be visited during a walk. A node's
      # reader is only called when the node's class actually defines it
      # via the type hierarchy (Document or Package).
      TYPES = %i[classes data_types enums associations packages].freeze

      # Yield each element of the specified types from a document or
      # package hierarchy.
      #
      # @param root [Lutaml::Uml::Document, Lutaml::Uml::Package] The root
      # @param types [Array<Symbol>] Subset of {TYPES} to visit
      # @yield [element, package_path] Each element found and its package path
      def self.each_element(root, types: [:classes], &block)
        new(root, types: types).each_element(&block)
      end

      # Collect all elements as a flat array.
      #
      # @param root [Lutaml::Uml::Document, Lutaml::Uml::Package] The root
      # @param types [Array<Symbol>] Subset of {TYPES} to visit
      # @return [Array] Flat array of [element, package_path] pairs
      def self.collect(root, types: [:classes])
        results = []
        each_element(root, types: types) { |element, path| results << [element, path] }
        results
      end

      def initialize(root, types: [:classes])
        @root = root
        @types = types
      end

      def each_element
        walk(@root, "") { |element, path| yield element, path }
      end

      private

      def walk(node, current_path)
        @types.each do |type|
          next unless TYPES.include?(type)
          next unless walkable?(node)

          collection = node.public_send(type)
          next unless collection

          collection.each { |element| yield element, current_path }
        end

        recurse_into_packages(node, current_path)
      end

      # Recurse into sub-packages. Yields nothing if the node cannot
      # own packages.
      def recurse_into_packages(node, current_path)
        return unless walkable?(node)

        packages = node.packages
        return unless packages

        packages.each do |pkg|
          pkg_path = current_path.empty? ? pkg.name.to_s : "#{current_path}::#{pkg.name}"
          walk(pkg, pkg_path) { |element, path| yield element, path }
        end
      end

      # Walkable nodes are the two container types in the UML hierarchy.
      # Anything else (e.g. a stray Classifier) has no typed collections
      # to walk.
      def walkable?(node)
        node.is_a?(Lutaml::Uml::Package) || node.is_a?(Lutaml::Uml::Document)
      end
    end
  end
end
