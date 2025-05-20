class UserPolicy < ApplicationPolicy
  attr_reader :user, :record

  def update?
    if record.email == "admin01@example.com"
      user.email == "admin01@example.com"
    else
      user == record || user.admin?
    end
  end

  def destroy?
    return false if record.email == "admin01@example.com"
    user.admin?
  end

  def index?
    user.admin? || user.email == "admin01@example.com"
  end

  def show?
    user.admin? || user == record
  end
end
