AdminUser.find_or_initialize_by(email: ENV['ADMIN_EMAIL'] || Rails.application.credentials.dig(:admin, :email)) do |admin_user|
	admin_user.password = ENV['ADMIN_PASSWORD'] || Rails.application.credentials.dig(:admin, :password)
	admin_user.password_confirmation = ENV['ADMIN_PASSWORD'] ||Rails.application.credentials.dig(:admin, :password)
	admin_user.save
end

Role.find_or_initialize_by(role_id: 'user').save
