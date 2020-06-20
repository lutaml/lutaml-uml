# frozen_string_literal: true

module Lutaml
  module Uml
    module Representers
      class Association < TopElement
        attr_accessor :owned_end, :member_end

        def initialize
          @name = nil
          @xmi_id = nil
          @xmi_uuid = nil
          @owned_end = []
          @member_end = []
          @namespace = nil
        end
      end
    end
  end
end
