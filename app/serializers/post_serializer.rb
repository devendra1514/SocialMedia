class PostSerializer
  include JSONAPI::Serializer
  attributes :post_id, :title, :likes_count, :comments_count, :created_at

  attribute :author do |object, params|
    post_author = params[:post_author]

    # pass post_author if fetching current user post
    if post_author.present?
      {
        user_id: post_author.user_id,
        name: post_author.name
      }
    else
      user = object.user
      {
        user_id: user.user_id,
        name: user.name
      }
    end

  end

  attribute :liked do |object, params|
    current_user = params[:current_user]
    is_current_user_like_post = params[:is_current_user_like_post]

    # pass current_user and is_current_user_like_post if fetching current user liked post
    if current_user.present? && is_current_user_like_post
      true
    elsif current_user.present?
      object.likes.exists?(user_id: current_user.user_id)
    else
      false
    end
  end
end
