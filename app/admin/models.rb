ActiveAdmin.register User do
  filter :username
  filter :full_phone_number
  index do
    id_column
    column :username
    column :full_phone_number
    actions
  end
end

ActiveAdmin.register Post do
  filter :title
  filter :user_id
  index do
    id_column
    column :title
    column :user_id
    actions
  end
end

ActiveAdmin.register Comment do
  filter :title
  filter :user_id
  filter :resource_type
  filter :resource_id
  index do
    id_column
    column :title
    column :user_id
    column :commentable_type
    column :commentable_id
    actions
  end
end
