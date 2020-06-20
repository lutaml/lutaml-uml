# frozen_string_literal: true

module Lutaml
  module Uml
    module Representers
      class TopElement
        attr_accessor :name, :xmi_id, :xmi_uuid, :namespace, :stereotype, :href, :visibility

        def initialize
          @name = nil
          @xmi_id = nil
          @xmi_uuid = nil
          @namespace = nil
          @href = nil
          @visibility = 'public'
        end

        def full_name
          if name == nil
            return nil
          end

          the_name = name
          next_namespace = namespace

          while !next_namespace.nil?
            the_name = if !next_namespace.name.nil?
                         next_namespace.name + '::' + the_name
                       else
                         '::' + the_name
                       end
            next_namespace = next_namespace.namespace
          end

          the_name
        end
      end
    end
  end
end
