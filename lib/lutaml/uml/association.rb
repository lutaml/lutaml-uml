# frozen_string_literal: true

module Lutaml
  module Uml
    class Association < TopElement
      include HasMembers

      attr_accessor :owner_end,
                    :owner_end_attribute_name,
                    :owner_end_cardinality,
                    :owner_end_type,
                    :member_end,
                    :member_end_attribute_name,
                    :member_end_cardinality,
                    :member_end_type,
                    :static,
                    :action
    end
  end
end
