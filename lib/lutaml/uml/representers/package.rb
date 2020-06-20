# frozen_string_literal: true

module Lutaml
  module Uml
    module Representers
      class Package < TopElement
        attr_accessor :imports, :contents

        def initialize
          @imports = []
          @contents = []
          @name = nil
          @xmi_id = nil
          @xmi_uuid = nil
          @namespace = nil
          @href = nil
        end
      end
    end
  end
end
