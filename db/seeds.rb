User.find_or_create_by!(email: "admin01@example.com") do |user|
  user.name = "Admin 01"
  user.password = "admin123"
  user.password_confirmation = "admin123"
  user.role = :admin
end
