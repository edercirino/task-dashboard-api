class Api::V1::AuthController < ApplicationController
  before_action :authorize_request, only: [ :register, :update, :destroy ]

  before_action :authorize_admin!, only: [ :register ], if: -> { @current_user.present? }

  def authorize_admin!
    unless @current_user&.role == "admin"
      render json: { error: "Only admins can assign roles" },
      status: :forbidden unless @current_user&.role == "admin"
    end
  end

  def login
    user = User.find_by(email: params[:email])

    if user&.authenticate(params[:password])
      token = jwt_encode(user_id: user.id)

      render json: {
        token: token,
        user: {
          id: user.id,
          role: user.role,
          name: user.name,
          email: user.email
        }
      }, status: :ok
    else
      render json: { error: "Invalid email or password" }, status: :unauthorized
    end
  end

  def register
    user = User.new(user_params)

    if user.save
      if @current_user&.role == "admin"
        render json: { message: "User created successfully", user: user }, status: :created
      else
        token = jwt_encode(user_id: user.id)
        render json: { token: token, user: user }, status: :created
      end
    else
      render json:
      { errors: user.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def update
    authorize @current_user, policy_class: UserPolicy

    if @current_user.update(user_params)
      render json: { user: @current_user }, status: :ok
    else
      render json:
      { errors: @current_user.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def destroy
    user = User.find(params[:id])
    authorize user

    if user.email == "admin01@example.com"
      render json: { error: "This user cannot be deleted." }, status: :forbidden
    else
      user.destroy
      render json: { message: "User deleted successfully" }
    end
  end

  private

  def jwt_encode(payload, exp = 24.hours.from_now)
    payload[:exp] = exp.to_i
    JWT.encode(payload, Rails.application.credentials.secret_key_base)
  end

  def user_params
    allowed = [ :name, :email, :password, :password_confirmation ]
    allowed << :role if @current_user&.role =="admin"
    params.require(:user).permit(allowed)
  end
end
