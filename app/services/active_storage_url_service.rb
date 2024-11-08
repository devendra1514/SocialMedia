class ActiveStorageUrlService
  include Rails.application.routes.url_helpers

  def initialize(file, host="http://localhost:3000")
    @file = file
    @host = host
  end

  def url
    return nil unless @file.attached?

    if Rails.env.test? || Rails.env.development?
      return @host + rails_blob_url(@file, only_path: true)
    end

    if Rails.env.production?
      prod_url(@file.blob.key)
    end
  end

  def thumb_url
    return nil unless @file.attached?

    return nil unless @file.representable? # this will check that is @file is representable or not

    if @file.image?
      thumb_blob = @file.variant(resize_to_fill: SMALL_THUMB_SIZE)
    elsif @file.video?
      thumb_blob = @file.preview(resize_to_fill: MEDIUM_THUMB_SIZE)
    end

    if Rails.env.test? || Rails.env.development?
      return @host + rails_blob_url(thumb_blob, only_path: true)
    end

    if Rails.env.production?
      prod_url(@file.blob.key)
    end
  rescue => e
    e.message
  end

  private

  def prod_url(thumb_key)
    project_id = Rails.application.credentials.dig(:supabase, :project_id)
    bucket = Rails.application.credentials.dig(:supabase, :bucket)
    "https://#{project_id}.supabase.co/storage/v1/object/public/#{bucket}/#{thumb_key}"
  end
end
