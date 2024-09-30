# frozen_string_literal: true

class Ability
  include CanCan::Ability

  def initialize(user)
    can :read, Post
    can :read, Comment
    can :read, Like
    can :read, User

    return unless user.present?
    can :manage, Post, user: user
    can :manage, Comment, user: user
    can :manage, Like, user: user
  end
end
