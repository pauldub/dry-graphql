require 'graphql/types'
require 'dry/core/class_attributes'

module Dry
  module GraphQL
    # Class to Ruby types to GraphQL types
    class TypeMappings
      class UnmappableTypeError < StandardError; end

      extend Dry::Core::ClassAttributes

      defines :registry
      registry(
        ::String => ::GraphQL::Types::String,
        ::Integer => ::GraphQL::Types::Int,
        ::TrueClass => ::GraphQL::Types::Boolean,
        ::FalseClass => ::GraphQL::Types::Boolean,
        ::Float => ::GraphQL::Types::Float,
        ::Date => ::GraphQL::Types::ISO8601DateTime
      )

      class << self
        def map_type(type)
          registry.fetch(type) do
            raise UnmappableTypeError,
                  "Cannot map #{type}. Please make sure " \
                  "it is registered by calling:\n" \
                  "Dry::GraphQL.register_type_mapping #{type}, MyGraphQLType"
          end
        end

        def mappable?(type)
          keys = registry.keys
          keys.include?(type)
        end
      end
    end
  end
end