class Types::UserType < Types::BaseObject
  field :id, ID, null: false
  field :name, String, null: false
  field :last_name, String, null: false
  field :email, String, null: false
  field :age, Integer, null: true
end
