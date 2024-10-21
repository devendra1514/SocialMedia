class ActiveStorageUrlService
  include Rails.application.routes.url_helpers

  def initialize(file, host="http://localhost:3000")
    @file = file
    @host = host
  end

  def url
    return unless @file.attached?

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
    return unless @file.attached?

    if @file.image?
      thumb_blob = @file.variant(resize_to_fill: [100, 100]).processed
    elsif @file.video?
      thumb_blob = @file.preview(resize_to_fill: [300, 300]).processed
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
  end
end
