class UserSerializer
  include JSONAPI::Serializer
  attributes :user_id, :name, :full_phone_number, :role_id, :posts_count
end
