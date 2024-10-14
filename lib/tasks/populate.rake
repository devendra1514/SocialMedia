# lib/tasks/populate.rake

namespace :db do
  desc "Populate database with large records excluding admin-related tables"
  task populate: :environment do
    require 'faker'

    # Clear existing data
    puts 'Destroying DirectMessages...'
    DirectMessage.destroy_all
    puts 'Destroying GroupMessages...'
    GroupMessage.destroy_all
    puts 'Destroying Follows...'
    Follow.destroy_all
    puts 'Destroying Groups...'
    Group.destroy_all
    puts 'Destroying Likes...'
    Like.destroy_all
    puts 'Destroying Comments...'
    Comment.destroy_all
    puts 'Destroying Posts...'
    Post.destroy_all
    puts 'Destroying Users...'
    User.destroy_all

    puts 'Creating Roles...'
    # Create roles if not already present
    role = Role.find_or_initialize_by(role_id: 'user')
    role.save


    puts 'Creating Users...'
    users = []
    50.times do
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


    puts 'Creating Sports Posts...'
    posts = []
    users.each do |user|
      rand(5..10).times do
        post = Post.new(
          user: user,
          title: Faker::Quote.jack_handey,
          created_at: (1..20).to_a.sample.days.ago
        )
        posts << post if post.save
      end
    end


    puts 'Creating Comments...'
    comments = []
    posts.each do |post|
      rand(2..10).times do
        comment = Comment.new(
          title: Faker::Quote.jack_handey,
          commentable: post,
          user: users.sample,
          created_at: (1..20).to_a.sample.days.ago
        )
        comments << comment if comment.save
      end
    end


    puts 'Creating Likes for Posts...'
    posts.each do |post|
      rand(1..2).times do
        like = Like.new(
          user: users.sample,
          likeable: post
        )
        like.save
      end
    end


    puts 'Creating Likes for Comments...'
    comments.each do |comment|
      rand(1..2).times do
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
      rand(0..3).times do
        group = Group.new(
          name: Faker::Quote.singular_siegler,
          username: Faker::Internet.username,
          creator: user,
          created_at: (1..20).to_a.sample.days.ago
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
    50.times do
      message = GroupMessage.new(
        content: Faker::Quote.famous_last_words,
        sender: users.sample,
        group: groups.sample,
        created_at: (1..20).to_a.sample.days.ago
      )
      message.save
    end


    puts 'Creating Direct Messages...'
    50.times do
      message = DirectMessage.new(
        content: Faker::Quote.famous_last_words,
        sender: users.sample,
        recipient: users.sample,
        created_at: (1..20).to_a.sample.days.ago
      )
      message.save
    end

    puts 'Creating Sports Moments...'
    moments = []
    users.each do |user|
      rand(5..10).times do
        moment = Moment.new(
          user: user,
          title: Faker::Quote.jack_handey,
          created_at: (1..20).to_a.sample.days.ago
        )
        moments << moment if moment.save
      end
    end

    puts 'Creating Likes for Moment...'
    moments.each do |moment|
      rand(1..2).times do
        like = Like.new(
          user: users.sample,
          likeable: moment
        )
        like.save
      end
    end

    puts 'Creating Views for Moment...'
    moments.each do |moment|
      rand(1..2).times do
        view = View.new(
          user: users.sample,
          viewable: moment
        )
        view.save
      end
    end

    puts 'Seeding completed successfully!'
  end
end
