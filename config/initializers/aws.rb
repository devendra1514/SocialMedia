Aws.config[:credentials] = Aws::Credentials.new(Rails.application.credentials.dig(:supabase, :storage, :access_key_id).to_s, Rails.application.credentials.dig(:supabase, :storage, :secret_access_key).to_s)

Aws.config.update(
  region: 'ap-south-1',
  credentials: Aws::Credentials.new(Rails.application.credentials.dig(:supabase, :storage, :access_key_id).to_s,
    Rails.application.credentials.dig(:supabase, :storage, :secret_access_key).to_s),
  endpoint: 'https://wwvynhbxuqkrfjpnxmnq.supabase.co/storage/v1/s3'
)
