class TaskPolicy < ApplicationPolicy
  def index?
    user.admin? || record.user_id == user.id
  end

  def show?
    user.admin? || record.user_id == user.id
  end

  def create?
    user.admin? || record.user_id == user.id
  end

  def update?
    user.admin? || record.user_id == user.id
  end

  def destroy?
    user.admin? || record.user_id == user.id
  end

  class Scope < Scope
    def resolve
      user.admin? ? scope.all : scope.where(user_id: user.id)
    end
  end
end
