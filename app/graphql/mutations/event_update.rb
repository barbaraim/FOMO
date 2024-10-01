# frozen_string_literal: true

module Mutations
  class EventUpdate < BaseMutation
    description "Updates a event by id"

    field :event, Types::EventType, null: false

    argument :id, ID, required: true
    argument :event_input, Types::EventInputType, required: false

    def resolve(id:, event_input:)
      event = ::Event.find(id)
      raise GraphQL::ExecutionError, "Login to update events" unless context[:current_user]
      raise GraphQL::ExecutionError, "You have to be the author of the event to modify it" unless context[:current_user].id == event.user_id
      raise GraphQL::ExecutionError.new "Error updating event", extensions: event.errors.to_hash unless event.update(**event_input)

      { event: event }
    end
  end
end
