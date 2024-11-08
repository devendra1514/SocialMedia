# Aws.config[:credentials] =
#   Aws::Credentials.new(
#     Rails.application.credentials.dig(:supabase, :storage, :access_key_id).to_s,
#     Rails.application.credentials.dig(:supabase, :storage, :secret_access_key).to_s
#   )

# Aws.config.update(
#   region: Rails.application.credentials.dig(:supabase, :storage, :region).to_s,
#   credentials: Aws::Credentials.new(
#     Rails.application.credentials.dig(:supabase, :storage, :access_key_id).to_s,
#     Rails.application.credentials.dig(:supabase, :storage, :secret_access_key).to_s),
#   endpoint: Rails.application.credentials.dig(:supabase, :storage, :endpoint).to_s
# )
