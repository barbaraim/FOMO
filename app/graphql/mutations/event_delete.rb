# frozen_string_literal: true

module Mutations
  class EventDelete < BaseMutation
    description "Deletes a event by ID"

    field :event, Types::EventType, null: false

    argument :id, ID, required: true

    def resolve(id:)
      event = ::Event.find(id)
      raise GraphQL::ExecutionError, "Login to delete events" unless context[:current_user]
      raise GraphQL::ExecutionError, "You have to be the author of the event to modify it" unless context[:current_user].id == event.user_id
      raise GraphQL::ExecutionError.new "Error deleting event", extensions: event.errors.to_hash unless event.destroy!

      { event: event }
    end
  end
end
