##
## Behaviour metamodel
##
module Lutaml::Uml

class Transition < TopElement
	attr_accessor :source, :target, :guard, :effect
end

end
