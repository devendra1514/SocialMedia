namespace :db do
  desc "Populate database with large records"
  task populate: :environment do
    require 'faker'

    # Clear existing data
    puts 'Destroying Users...'
    User.destroy_all

    puts 'Creating Roles...'
    role = Role.find_or_create_by(name: 'user')

    puts 'Creating Users...'
    users = []
    500.times do
      name = Faker::Name.name
      username = Faker::Internet.username(specifier: name, separators: %w(. _ ))
      user = User.new(
        name: name,
        username: username,
        full_phone_number: "+9195#{rand(10000000..99999999)}",
        password: 'Test@123',
        role_id: role.role_id
      )
      users << user if user.save
    end


    puts 'Creating Posts...'
    posts = []
    users.each do |user|
      rand(1..5).times do
        post = Post.new(
          user: user,
          title: Faker::Quote.jack_handey,
          created_at: (0..10).to_a.sample.days.ago
        )
        posts << post if post.save
      end
    end


    puts 'Creating Comments...'
    comments = []
    posts.each do |post|
      rand(1..3).times do
        comment = Comment.new(
          title: Faker::Quote.jack_handey,
          commentable: post,
          user: users.sample,
          created_at: (0..10).to_a.sample.days.ago
        )
        comments << comment if comment.save
      end
    end


    puts 'Creating Comments of Comments...'
    child_comments = []
    comments.each do |post|
      rand(1..2).times do
        comment = Comment.new(
          title: Faker::Quote.jack_handey,
          commentable: post,
          user: users.sample,
          created_at: (0..10).to_a.sample.days.ago
        )
        child_comments << comment if comment.save
      end
    end


    puts 'Creating Likes for Posts...'
    posts.each do |post|
      rand(1..25).times do
        like = Like.new(
          user: users.sample,
          likeable: post
        )
        like.save
      end
    end


    puts 'Creating Likes for Comments...'
    comments.each do |comment|
      rand(1..25).times do
        like = Like.new(
          user: users.sample,
          likeable: comment
        )
        like.save
      end
    end


    puts 'Creating Follows...'
    users.each do |user|
      rand(2..10).times do
        follow = Follow.new(
          follower: user,
          followed: users.sample
        )
        follow.save
      end
    end


    puts 'Creating Groups...'
    groups = []
    users.each do |user|
      rand(0..2).times do
        group = Group.new(
          name: Faker::Company.name,
          username: Faker::Internet.username,
          creator: user,
          created_at: (1..10).to_a.sample.days.ago
        )
        groups << group if group.save
      end
    end


    puts 'Creating Group Memberships...'
    groups.each do |group|
      rand(1..10).times do
        membership = GroupMembership.new(
          member: users.sample,
          group: group
        )
        membership.save
      end
    end


    puts 'Creating Group Messages...'
    rand(1..10).times do
      message = GroupMessage.new(
        content: Faker::Quote.famous_last_words,
        sender: users.sample,
        group: groups.sample,
        created_at: (1..20).to_a.sample.days.ago
      )
      message.save
    end


    puts 'Creating Direct Messages...'
    rand(1..10).times do
      message = DirectMessage.new(
        content: Faker::Quote.famous_last_words,
        sender: users.sample,
        recipient: users.sample,
        created_at: (1..20).to_a.sample.days.ago
      )
      message.save
    end

    puts 'Seeding completed successfully!'
  end
end
