class ActiveStorageUrlService
  include Rails.application.routes.url_helpers

  def initialize(file, host="http://localhost:3000")
    @file = file
    @host = host
  end

  def url
    return nil unless @file.attached?

    if Rails.env.test?
      return @host + rails_blob_url(@file, only_path: true)
    end

    project_id = Rails.application.credentials.dig(:supabase, :project_id)
    if Rails.env.development?
      return "https://#{project_id}.supabase.co/storage/v1/object/public/Development/#{@file.blob.key}"
    end

    if Rails.env.production?
      return "https://#{project_id}.supabase.co/storage/v1/object/public/Production/#{@file.blob.key}"
    end
  end

  def thumb_url
    return nil unless @file.attached?

    return nil unless @file.representable? # this will check for varient key is present or not

    if @file.image?
      thumb_blob = @file.variant(resize_to_fill: SMALL_THUMB_SIZE)
    elsif @file.video?
      thumb_blob = @file.preview(resize_to_fill: MEDIUM_THUMB_SIZE)
    end

    if Rails.env.test?
      return @host + rails_blob_url(thumb_blob, only_path: true)
    end

    project_id = Rails.application.credentials.dig(:supabase, :project_id)
    if Rails.env.development?
      return "https://#{project_id}.supabase.co/storage/v1/object/public/Development/#{thumb_blob.key}"
    end

    if Rails.env.production?
      return "https://#{project_id}.supabase.co/storage/v1/object/public/Production/#{thumb_blob.key}"
    end
  rescue => e
    e.message
  end
end
