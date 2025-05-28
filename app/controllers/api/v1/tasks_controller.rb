class Api::V1::TasksController < ApplicationController
  include Pundit

  before_action :authorize_request
  before_action :set_user, only: [ :create ]
  before_action :set_task, only: [ :show, :update, :destroy ]

  def index
    if current_user.admin? && params[:user_id].present?
      user = User.find(params[:user_id])
      @tasks = policy_scope(Task).where(user_id: user.id)
    else
      @tasks = policy_scope(Task)
    end
  render json: @tasks
  end

  def show
    authorize @task
    @task = Task.includes(:user).find(params[:id])
    render json: @task.as_json(include: { user: { only: [ :id, :name ] } })
  end

  def create
    @task = @user.tasks.build(task_params)
    authorize @task

    if @task.save
      render json: @task, status: :created
    else
      render json: { errors: @task.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def update
    authorize @task
    if @task.update(task_params)
      if task_params[:status] == "done" && @task.completed_at.nil?
        @task.update(completed_at: Time.current)
      elsif task_params[:status] == "pending"
        @task.update(completed_at: nil)
      end
      render json: @task
    else
      render json: { errors: @task.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def destroy
    authorize @task
    @task.destroy
    head :no_content
  end

  private

  def set_user
    @user = User.find(params[:user_id])

    unless current_user.admin? || current_user.id == @user.id
      render json: { error: "Not authorized to access this task" }, status: :forbidden
    end
  end

  def set_task
    @task = Task.find(params[:id])
  end

  def task_params
      params.require(:task).permit(:title, :description, :status)
  end
end
