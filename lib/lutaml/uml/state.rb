##
## Behaviour metamodel
##
module Lutaml::Uml

class State < Vertex
	attr_accessor :exit, :entry, :do_activity
end

end
