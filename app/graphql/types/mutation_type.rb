# frozen_string_literal: true

module Types
  class MutationType < Types::BaseObject
    field :event_delete, mutation: Mutations::EventDelete
    field :event_update, mutation: Mutations::EventUpdate
    field :event_create, mutation: Mutations::EventCreate
    field :sign_in_mutation, mutation: Mutations::SignInMutation
    # TODO: remove me
    field :test_field, String, null: false,
      description: "An example field added by the generator"
    def test_field
      "Hello World"
    end
  end
end
