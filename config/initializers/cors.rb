Rails.application.config.middleware.insert_before 0, Rack::Cors do
  allow do
    origins 'https://ray-large-cobra.ngrok-free.app', 'http://localhost:3001'
    resource '*', headers: :any, methods: [:get, :post, :put, :patch, :delete, :options, :head]
  end
end
