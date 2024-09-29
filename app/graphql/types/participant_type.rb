class ParticipantType < Types::BaseObject
  field :id, ID, null: false
  field :event, EventType, null: false
  field :user, UserType, null: false
  field :created_at, GraphQL::Types::ISO8601DateTime, null: false
  field :updated_at, GraphQL::Types::ISO8601DateTime, null: false
end
