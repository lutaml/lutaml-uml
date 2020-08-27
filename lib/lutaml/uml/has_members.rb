# frozen_string_literal: true

module Lutaml
  module Uml
    module HasMembers
      # TODO: move to Parslet::Transform
      def members=(value)
        value
          .select { |member| member.keys.length == 1 && !respond_to?("#{member.keys.first}=") }
          .group_by { |member| member.keys.first }
          .each do |(type, group)|
            next if respond_to?("#{type}=")

            public_send("#{associtaion_type(type)}=", group.map(&:values).flatten)
          end
        value
          .select { |member| member.keys.any? { |key| respond_to?("#{key}=") } }
          .each do |member|
            member.each_pair do |key, member_value|
              public_send("#{key}=", member_value) if respond_to?("#{key}=")
            end
          end
      end

      private

      def associtaion_type(type)
        return type if respond_to?("#{type}=")
        return "classes" if type == :class
        return "enums" if type == :enum
        return "attributes" if type == :attribute
        return "associations" if type == :association

        raise(UnknownMemberTypeError, "Unknown member type: #{type}")
      end
    end
  end
end
