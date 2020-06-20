# frozen_string_literal: true

##
## Behaviour metamodel
##
module Lutaml
  module Uml
    module Representers
      class Transition < TopElement
        attr_accessor :source, :target, :guard, :effect
      end
    end
  end
end
