module Lutaml::Uml

class Model < Package
	attr_accessor :viewpoint
	def initialize
		@contents = []
	end
end

end