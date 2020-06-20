# frozen_string_literal: true

module Lutaml
  module Uml
    module HasAttributes
      def update_attributes(attributes = {})
        attributes.to_h.each { |name, value| send("#{name}=", value) }
      end
    end
  end
end
