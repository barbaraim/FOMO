class EventType < Types::BaseObject
  field :id, ID, null: false
  field :name, String, null: false
  field :address, String, null: true
  field :start_date, GraphQL::Types::ISO8601DateTime, null: false
  field :end_date, GraphQL::Types::ISO8601DateTime, null: false
  field :created_at, GraphQL::Types::ISO8601DateTime, null: false
  field :updated_at, GraphQL::Types::ISO8601DateTime, null: false
  field :user, UserType, null: false
  field :participants, [ ParticipantType ], null: false
  # field :comments, [ CommentType ], null: false
end
