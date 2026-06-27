# frozen_string_literal: true

require "lutaml/model"

module Lutaml
  class Error < StandardError; end unless defined?(Error)

  module Uml
    VERSION = "0.2.0" unless defined?(VERSION)
    class Error < StandardError; end

    autoload :HasAttributes, "lutaml/uml/has_attributes"
    autoload :HasMembers, "lutaml/uml/has_members"
    autoload :ModelHelpers, "lutaml/uml/model_helpers"
    autoload :Namespace, "lutaml/uml/namespace"
    autoload :PackagePath, "lutaml/uml/package_path"
    autoload :QualifiedName, "lutaml/uml/qualified_name"

    # Value types
    autoload :Cardinality, "lutaml/uml/cardinality"
    autoload :Fidelity, "lutaml/uml/fidelity"
    autoload :Value, "lutaml/uml/value"
    autoload :TaggedValue, "lutaml/uml/tagged_value"
    autoload :Group, "lutaml/uml/group"

    # Core elements
    autoload :TopElement, "lutaml/uml/top_element"
    autoload :TopElementAttribute, "lutaml/uml/top_element_attribute"
    autoload :GeneralAttribute, "lutaml/uml/general_attribute"

    # Relationships
    autoload :AssociationGeneralization, "lutaml/uml/association_generalization"
    autoload :Generalization, "lutaml/uml/generalization"
    autoload :Association, "lutaml/uml/association"
    autoload :Dependency, "lutaml/uml/dependency"
    autoload :Abstraction, "lutaml/uml/abstraction"
    autoload :Realization, "lutaml/uml/realization"

    # Classifiers
    autoload :UmlClassifier, "lutaml/uml/classifier"
    autoload :UmlClass, "lutaml/uml/class"
    autoload :DataType, "lutaml/uml/data_type"
    autoload :Enum, "lutaml/uml/enum"
    autoload :PrimitiveType, "lutaml/uml/primitive_type"
    autoload :Actor, "lutaml/uml/actor"

    # Behavioral elements
    autoload :Action, "lutaml/uml/action"
    autoload :Behavior, "lutaml/uml/behavior"
    autoload :Activity, "lutaml/uml/activity"
    autoload :OpaqueBehavior, "lutaml/uml/opaque_behavior"

    # State machine elements
    autoload :Vertex, "lutaml/uml/vertex"
    autoload :State, "lutaml/uml/state"
    autoload :FinalState, "lutaml/uml/final_state"
    autoload :Pseudostate, "lutaml/uml/pseudostate"
    autoload :Region, "lutaml/uml/region"
    autoload :StateMachine, "lutaml/uml/state_machine"
    autoload :Transition, "lutaml/uml/transition"
    autoload :Event, "lutaml/uml/event"
    autoload :Trigger, "lutaml/uml/trigger"

    # Structural elements
    autoload :Property, "lutaml/uml/property"
    autoload :Port, "lutaml/uml/port"
    autoload :Operation, "lutaml/uml/operation"
    autoload :OperationParameter, "lutaml/uml/operation_parameter"
    autoload :Constraint, "lutaml/uml/constraint"

    # Composite elements
    autoload :Connector, "lutaml/uml/connector"
    autoload :ConnectorEnd, "lutaml/uml/connector_end"
    autoload :Package, "lutaml/uml/package"
    autoload :Model, "lutaml/uml/model"

    # Documentation
    autoload :Comment, "lutaml/uml/comment"
    autoload :Diagram, "lutaml/uml/diagram"
    autoload :DiagramObject, "lutaml/uml/diagram_object"
    autoload :DiagramLink, "lutaml/uml/diagram_link"
    autoload :Instance, "lutaml/uml/instance"
    autoload :Document, "lutaml/uml/document"

    # Validation
    module Validation
      autoload :BaseValidator, "lutaml/uml/validation/base_validator"
      autoload :DocumentStructureValidator,
               "lutaml/uml/validation/document_structure_validator"
    end
  end
end
