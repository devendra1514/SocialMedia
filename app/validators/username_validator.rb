class UsernameValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
    # Check if the username is present
    if value.blank?
      record.errors.add(attribute, "can't be blank")
      return
    end

    # Check if the username meets length requirements
    if value.length < 3 || value.length > 25
      record.errors.add(attribute, "must be between 3 and 25 characters")
    end

    # Check the format of the username (alphanumeric and underscores only)
    unless value =~ /\A[a-z0-9_.]+\z/
      record.errors.add(attribute, "only allows letters, numbers, dots and underscores")
    end

    # Add any additional custom validation logic here
  end
end
