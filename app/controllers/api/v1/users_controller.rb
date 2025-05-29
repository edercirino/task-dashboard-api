class Api::V1::UsersController < ApplicationController
  before_action :authorize_request
  before_action :set_user, only: [ :show, :update, :destroy ]

  def index
    authorize User, :index?, policy_class: UserPolicy
    users = User.all.order(:name)
    if params[:query].present?
      users = users.where("name ILIKE ? OR email ILIKE ?", "%#{params[:query]}%", "%#{params[:query]}%")
    end
    render json: users, status: :ok
  end

  def show
    user = User.find(params[:id])
    authorize user
    render json: {
      id: user.id,
      name: user.name,
      email: user.email,
      role: user.role
    }
  end

  def create
    authorize User
    user = User.new(user_params)

    if user.save
      render json: user, status: :create
    else
      render json: { errors: user.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def update
    user = User.find(params[:id])
    authorize @user

    if user.email == "admin01@example.com" && user != current_user
      render json: { error: "You can't change the master admin's data" }, status: :forbidden
      return
    end

    if @user.update(user_params)
      render json: { message: "User update successfully", user: user }, status: :ok
    else
      render json: { errors: @user.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def destroy
    authorize @user

    if @user.email == "admin01@example.com"
      render json: { error: "This user cannot be deleted" }, status: :forbidden
    else
      @user.destroy
      render json: { message: "User deleted successfully" }
    end
  end

  private

  def set_user
    @user = User.find(params[:id])
  end

  def user_params
    allowed = [ :name, :email, :password, :password_confirmation ]
    allowed << :role if current_user.admin?
    params.require(:user).permit(allowed)
  end
end
