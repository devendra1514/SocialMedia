class MimeTypeValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
    if value.attached?
      mime_type = MIME::Types[value.content_type].first
      allowed_types = Array(options[:media_type])

      unless mime_type && allowed_types.include?(mime_type.media_type)
        record.errors.add(attribute, :file_type, allowed_types: allowed_types.join(' or '))
      end

      if options[:max_size].present? && value.blob.byte_size > options[:max_size]
        record.errors.add(attribute, :file_size, size: "#{options[:max_size] / 1.megabytes}")
      end
    end
  end
end
