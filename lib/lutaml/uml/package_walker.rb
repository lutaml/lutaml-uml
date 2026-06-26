# frozen_string_literal: true

module Lutaml
  module Uml
    class PackageWalker
      # Yield each element of the specified types from a document or package hierarchy.
      #
      # @param root [Lutaml::Uml::Document, Lutaml::Uml::Package] The root to walk
      # @param types [Array<Symbol>] Which collections to visit (:classes, :data_types, :enums, :associations, :packages)
      # @yield [element, package_path] Each element found and its package path
      def self.each_element(root, types: [:classes], &block)
        new(root, types: types).each_element(&block)
      end

      # Collect all elements as a flat array.
      #
      # @param root [Lutaml::Uml::Document, Lutaml::Uml::Package] The root to walk
      # @param types [Array<Symbol>] Which collections to visit
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

      def each_element(&block)
        walk(@root, "", &block)

      private

      def walk(node, current_path)
        @types.each do |type|
          next unless node.respond_to?(type)

          collection = node.public_send(type)
          next unless collection

          collection.each do |element|
            yield element, current_path

        # Recurse into sub-packages
        return unless node.respond_to?(:packages)

        packages = node.packages
        return unless packages

        packages.each do |pkg|
          pkg_path = current_path.empty? ? pkg.name.to_s : "#{current_path}::#{pkg.name}"
          walk(pkg, pkg_path)
