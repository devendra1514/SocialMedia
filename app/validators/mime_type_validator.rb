class MimeTypeValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
    if value.attached?
      mime_type = MIME::Types[value.content_type].first
      allowed_types = Array(options[:media_type])

      unless mime_type && allowed_types.include?(mime_type.media_type)
        record.errors.add(attribute, "Invalid file type. Please upload a #{allowed_types.join(' or ')} file.")
      end

      if options[:max_size].present? && value.blob.byte_size > options[:max_size]
        record.errors.add(attribute, "File size should be less than #{options[:max_size] / 1.megabyte} MB.")
      end
    end
  end
end
