class Api::V1::UsersController < ApplicationController
  before_action :authorize_request
  before_action :set_user, only: [ :show, :update, :destroy ]

  def index
    authorize User, :index?, policy_class: UserPolicy
    users = User.all.order(:name)
    render json: users, status: :ok
  end

  def show
    user = User.find(params[:id])
    authorize user
    render json: {
      user: user,
      tasks: user.tasks
    }, status: :ok
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
    authorize @user

    if @user.update(user_params)
      render json: @user
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
