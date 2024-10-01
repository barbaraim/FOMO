module Api
  module V1
    class Users::RegistrationsController < Devise::RegistrationsController
      include RackSessionsFix
      protect_from_forgery with: :exception, if: Proc.new { |c| c.request.format != "application/json" }
      protect_from_forgery with: :null_session, if: Proc.new { |c| c.request.format == "application/json" }

      respond_to :json
      private

      def respond_with(current_user, _opts = {})
        if resource.persisted?
          render json: {
            status: { code: 200, message: "Signed up successfully." },
            data: UserSerializer.new(current_user).serializable_hash[:data][:attributes]
          }
        else
          render json: {
            status: { message: "User couldn't be created successfully. #{current_user.errors.full_messages.to_sentence}" }
          }, status: :unprocessable_entity
        end
      end

      def sign_up_params
        params.require(:user).permit(:username, :email, :password, :password_confirmation, :name, :last_name)
      end
    end
  end
end


# {"authenticity_token"=>"[FILTERED]", "user"=>{"email"=>"[FILTERED]", "password"=>"[FILTERED]", "password_confirmation"=>"[FILTERED]", "name"=>"Humberto", "last_name"=>"Ortuzar"}, "commit"=>"Sign up"}
