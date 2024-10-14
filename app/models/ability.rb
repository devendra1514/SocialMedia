# frozen_string_literal: true

# read: [:index, :show]
# create: [:new, :create]
# update: [:edit, :update]
# destroy: [:destroy]

class Ability
  include CanCan::Ability

  def initialize(current_user)

    return unless current_user.present?

    can %i[read create], Post
    can %i[update destroy], Post, user_id: current_user.user_id

    can %i[read create], Comment
    can %i[update destroy], Comment, user_id: current_user.user_id

    can %i[read create], Group
    can %i[update destroy], Group, user_id: current_user.user_id

    can %i[create destroy], GroupMembership do |group_membership|
      group_membership.group.user_id == current_user.user_id
    end

    can %i[read], GroupMessage
    can %i[create], GroupMessage do |group_message|
      group_message.group.members.exists?(user_id: current_user.user_id)
    end
    can %i[update destroy], GroupMessage do |group_message|
      group_message.sender == current_user
    end

    can %i[update destroy], DirectMessage do |direct_message|
      direct_message.sender == current_user
    end

    can %i[read create], Moment
    can %i[update destroy], Moment, user_id: current_user.user_id
  end
end
