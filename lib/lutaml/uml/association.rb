# frozen_string_literal: true

module Lutaml
  module Uml
    class Association < TopElement
      attr_accessor :owned_end,
                    :owned_end_attribute_name,
                    :owned_end_cardinality,
                    :owned_end_type,
                    :member_end,
                    :member_end_attribute_name,
                    :member_end_cardinality,
                    :member_end_type,
                    :static,
                    :action
    end
  end
end
