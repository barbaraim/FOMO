# frozen_string_literal: true

module Mutations
  class EventCreate < BaseMutation
    description "Creates a new event"

    field :event, Types::EventType, null: false

    argument :event_input, Types::EventInputType, required: true

    def resolve(event_input:)
      raise GraphQL::ExecutionError, "Login to create events" unless context[:current_user]
      event = ::Event.new(**event_input)
      event.user = context[:current_user]
      raise GraphQL::ExecutionError.new "Error creating event", extensions: event.errors.to_hash unless event.save
      { event: event }
    end
  end
end
