# frozen_string_literal: true

module Lutaml
  module Uml
    class Association < TopElement
      attr_accessor :owned_end,
                    :member_end,
                    :type,
                    :static
    end
  end
end
