##
## Behaviour metamodel
##

module Lutaml::Uml

class Actor < Classifier
	def initialize
		@name = nil
		@xmi_id = nil
		@stereotype = []
		@generalization = []
		@namespace = nil
	end
end

end