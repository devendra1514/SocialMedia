class ActiveStorageUrlService
  include Rails.application.routes.url_helpers

  def initialize(file, host="http://localhost:3000")
    @file = file
    @host = host
  end

  def call
    return unless @file.attached?

    # (Rails.env.development? || Rails.env.test?) ?
    #   (@host + rails_blob_url(@file, only_path: true)) :
    # @file.service.send(:object_for, @file.key).public_url

    project_id = Rails.application.credentials.dig(:supabase, :project_id)
    "https://#{project_id}.supabase.co/storage/v1/object/public/Development/#{@file.blob.key}}"
  end
end
