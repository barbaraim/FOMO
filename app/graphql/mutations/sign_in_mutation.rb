# frozen_string_literal: true

module Mutations
  class SignInMutation < BaseMutation
    argument :email, String, required: true
    argument :password, String, required: true

    field :token, String, null: true
    field :error, String, null: true

    def resolve(email:, password:)
      raise GraphQL::ExecutionError, "User already signed in" if context[:current_user]
      user = User.find_by_email(email.downcase)
      return { error: 'Username or Password is incorrect' } unless user.valid_password?(password)
      {
        token: JWT.encode({ sub: user.id }, Rails.application.credentials.devise_jwt_secret_key!),
        error: ''
      }
    end
  end
end
