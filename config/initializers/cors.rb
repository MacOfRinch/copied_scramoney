Rails.application.config.middleware.insert_before 0, Rack::Cors do
  allow do
    origins '*'
    resource '/*', methods: %i[get post put patch delete options head], headers: :any
  end
end
