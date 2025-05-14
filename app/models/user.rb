class User < ApplicationRecord
  has_secure_password

  validates :name, presence: true
  validates :email, presence: true, uniqueness: true
  validates :password, length: { minimum: 6 }, allow_blank: true
  validates :role, inclusion: { in: %w[user admin], message: "%{value} is not valid role" }
end
