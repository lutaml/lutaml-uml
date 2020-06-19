module Lutaml::Uml

class Instance < TopElement
	attr_accessor :classifier, :slot
	def initialize
		@name = nil
		@xmi_id = nil
		@xmi_uuid = nil
		@classifier = nil
		@slot = []
	end
end
