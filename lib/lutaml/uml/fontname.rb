# frozen_string_literal: true

# DEPRECATED 2026-06-27: unused — no caller references Lutaml::Uml::Fontname.
# Autoload entry removed from lib/lutaml/uml.rb. File kept per never-delete-
# source rule.

module Lutaml
  module Uml
    class Fontname < Lutaml::Model::Serializable
      skip_reference_registration

      attribute :name, :string

      yaml do
        map "name", to: :name
      end
    end
  end
end
