module Types
  class EventInputType < Types::BaseInputObject
    argument :name, String, required: true
    argument :address, String, required: true
    argument :start_date, GraphQL::Types::ISO8601DateTime, required: true
    argument :end_date, GraphQL::Types::ISO8601DateTime, required: true
    argument :description, String, required: true
  end
end
