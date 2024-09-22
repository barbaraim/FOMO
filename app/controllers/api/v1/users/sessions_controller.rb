module Api
  module V1
    class Users::SessionsController < Devise::SessionsController
      include RackSessionsFix
      protect_from_forgery with: :exception, if: Proc.new { |c| c.request.format != "application/json" }
      protect_from_forgery with: :null_session, if: Proc.new { |c| c.request.format == "application/json" }

      respond_to :json

      def create
        params = sign_in_params
        user = User.find_by_email(params["email"].downcase)
        if user.valid_password?(params["password"]) then
          sign_in(user)
          render json: {
          status: {
            code: 200, message: "Logged in successfully.",
            data: { user: UserSerializer.new(current_user).serializable_hash[:data][:attributes] }
          }
        }, status: :ok
        else
          render json: {
          status: {
            code: 401, message: "User or Password incorrect."
          }
        }, status: :ok
        end
      end

      private
      def respond_with(current_user, _opts = {})
        render json: {
          status: {
            code: 200, message: "Logged in successfully.",
            data: { user: UserSerializer.new(current_user).serializable_hash[:data][:attributes] }
          }
        }, status: :ok
      end

      def respond_to_on_destroy
        if request.headers["Authorization"].present?
          jwt_payload = JWT.decode(request.headers["Authorization"].split(" ").last, Rails.application.credentials.devise_jwt_secret_key!).first
          current_user = User.find(jwt_payload["sub"])
        end

        if current_user
          render json: {
            status: 200,
            message: "Logged out successfully."
          }, status: :ok
        else
          render json: {
            status: 401,
            message: "Couldn't find an active session."
          }, status: :unauthorized
        end
      end

      def sign_in_params
        params.require(:user).permit(:email, :password)
      end
    end
  end
end
