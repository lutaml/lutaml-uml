module Lutaml::Uml

  class TopElement
  	attr_accessor :name, :xmi_id, :xmi_uuid, :namespace, :stereotype, :href, :visibility

  	def initialize
  		@name = nil
  		@xmi_id = nil
  		@xmi_uuid = nil
  		@namespace = nil
  		@href = nil
  		@visibility = 'public'
  	end

  	def full_name
  		if self.name == nil
  			return nil
  		end

  		the_name = self.name
  		next_namespace = self.namespace

  		while next_namespace != nil
  			if next_namespace.name != nil
  				the_name = next_namespace.name + '::' + the_name
  			else
  				the_name = '::' + the_name
  			end
  		next_namespace = next_namespace.namespace
  		end

  		the_name

  	end
  end

end
