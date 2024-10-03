class ApplicationController < ActionController::Base
  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  allow_browser versions: :modern
  before_action :configure_permitted_parameters, if: :devise_controller?

  def graphql_current_user
    token = request.headers["Authorization"].to_s.split(" ").last
    return unless token
    jwt_payload = JWT.decode(token, Rails.application.credentials.devise_jwt_secret_key!)&.first
    return unless jwt_payload
    @current_user = User.find(jwt_payload["sub"])
  end

  protected
    def configure_permitted_parameters
      devise_parameter_sanitizer.permit(:sign_up, keys: [ :name, :last_name, :role, :age ])
      devise_parameter_sanitizer.permit(:account_update, keys: [ :name, :last_name, :role, :age ])
    end
end
