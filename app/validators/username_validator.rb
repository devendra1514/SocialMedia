class UsernameValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
    if value.blank?
      record.errors.add(attribute, "can't be blank")
      return
    end

    unless value =~ /\A[a-z0-9_.]+\z/
      record.errors.add(attribute, "'must be a-z, 0-9, underscore and dot'")
    end
  end
end
