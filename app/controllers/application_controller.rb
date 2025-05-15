class ApplicationController < ActionController::API
  include Pundit
  rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized

  private

  def user_not_authorized
    render json: { error: "You are not permitted to execute this action" }, status: :forbidden
  end

  def authorize_request
    header = request.headers["Authorization"]
    token = header.split(" ").last if header

    begin
      decoded = JWT.decode(token, Rails.application.credentials.secret_key_base)[0]
      @current_user = User.find(decoded["user_id"])
    rescue ActiveRecord::RecordNotFound, JWT::DecodeError
      render json: { errors: [ "Unauthorized" ] }, status: :unauthorized
    end
  end
end
