##
## Behaviour metamodel
##
module Lutaml::Uml

class ConnectorEnd < TopElement
	attr_accessor :role, :part_with_port, :connector
	def initialize
		@role = nil
	end
end

end