AdminUser.find_or_initialize_by(email: ENV['ADMIN_EMAIL'] || Rails.application.credentials.dig(:admin, :email)) do |admin_user|
	admin_user.password = ENV['ADMIN_PASSWORD'] || Rails.application.credentials.dig(:admin, :password)
	admin_user.password_confirmation = ENV['ADMIN_PASSWORD'] ||Rails.application.credentials.dig(:admin, :password)
	admin_user.save
end

Role.find_or_initialize_by(role_id: 'user').save


# Clear the database
User.destroy_all
Post.destroy_all
Comment.destroy_all
Like.destroy_all
Follow.destroy_all

# Create Users
puts 'Creating Users...'
users = []
5.times do
	name = Faker::Name.name
	username = Faker::Internet.username(specifier: name, separators: %w(. _ ))
  users << User.create!(
  	name: name,
    username: username,
    full_phone_number: "+9195165815#{rand(10..99)}",
    password: 'Test@123',
    role_id: Role.find_by(role_id: 'user').role_id
  )
end

# Create Posts for each User
puts 'Creating Posts...'
users.each do |user|
  rand(1..5).times do
    Post.create!(
      user: user,
      title: Faker::Lorem.sentence,
    )
  end
end

# Create Comments for each Post
puts 'Creating Comments...'
Post.all.each do |post|
  rand(1..3).times do
    Comment.create!(
      user: users.sample,
      commentable: post,
      title: Faker::Lorem.sentence
    )
  end
end

# Create Likes for Posts
puts 'Creating Likes...'
Post.all.each do |post|
  Like.create!(
    user: users.sample,
    likeable: post
  )
end

# Create Likes for Comments
Comment.all.each do |comment|
  Like.create!(
    user: users.sample,
    likeable: comment
  )
end

# Create Follows (Users following each other)
puts 'Creating Follows...'
users.each do |follower|
  followed_users = users.sample(rand(1..5)) - [follower]
  followed_users.each do |followed|
    Follow.create!(
      follower: follower,
      followed: followed
    )
  end
end

puts 'Seeding complete!'
