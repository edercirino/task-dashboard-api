class Api::V1::TasksController < ApplicationController
  before_action :authorize_request
  before_action :set_user
  before_action :set_task, only: [ :show, :update, :destroy ]

  def index
    @tasks = @user.tasks
    render json: @user.tasks
  end

  def show
    render json: @task
  end

  def create
    @task = @user.tasks.build(task_params)
    if @task.save
      render json: @task, status: :created
    else
      render json: { errors: @task.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def update
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
    @task.destroy
    head :no_content
  end

  private

  def set_user
    @user = User.find(params[:user_id])
  end

  def set_task
    @task = @user.tasks.find(params[:id])
  end

  def task_params
    params.require(:task).permit(:title, :description, :status)
  end
end
