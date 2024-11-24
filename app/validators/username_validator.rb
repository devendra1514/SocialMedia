class UsernameValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
    if value.blank?
      record.errors.add(attribute, :blank)
      return
    end

    unless value =~ /\A[a-z0-9_.]+\z/
      record.errors.add(attribute, :invalid)
    end
  end
end
