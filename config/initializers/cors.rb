Rails.application.config.middleware.insert_before 0, Rack.cors do
  allow do
    origins "http://localhost:5173"
    resource "*",
    headers: :any,
    methods: [ :get, :post, :patch, :put, :delete, :options ],
    expose: [ "Authorization" ]
  end
end
