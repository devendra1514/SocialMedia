class CommentSerializer
	include JSONAPI::Serializer
	attributes :comment_id, :title, :likes_count, :comments_count, :level

	attribute :author do |object, params|
		comment_author = params[:comment_author]

		if comment_author.present?
      {
				user_id: comment_author.user_id,
				name: comment_author.name
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
		is_current_user_like_comment = params[:is_current_user_like_comment]

		if current_user.present? && is_current_user_like_comment
      true
    elsif current_user.present?
    	object.likes.exists?(user_id: current_user.user_id)
    else
      false
    end
	end
end
