# frozen_string_literal: true

module Lutaml
  module Uml
    module HasMembers
      def members=(value)
        value
          .group_by { |member| member.keys.first }
          .map do |(type, group)|
            member_values = group.map(&:values).flatten
            public_send("#{associtaion_type(type)}=", member_values)
          end
      end

      private

      def associtaion_type(type)
        return "classes" if type == :class
        return "attributes" if type == :attribute

        raise(UnknownMemberTypeError, "Unknown member type: #{type}")
      end
    end
  end
end
