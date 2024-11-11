if Rails.env.production?
	AdminUser.find_or_initialize_by(email: Rails.application.credentials.dig(:admin, :email).to_s) do |admin_user|
		admin_user.password = Rails.application.credentials.dig(:admin, :password).to_s
		admin_user.password_confirmation = Rails.application.credentials.dig(:admin, :password).to_s
		admin_user.save
	end
else
	AdminUser.find_or_initialize_by(email: ENV['ADMIN_EMAIL']) do |admin_user|
		admin_user.password = ENV['ADMIN_PASSWORD']
		admin_user.password_confirmation = ENV['ADMIN_PASSWORD']
		admin_user.save
	end
end

Role.find_or_initialize_by(role_id: 'user').save
