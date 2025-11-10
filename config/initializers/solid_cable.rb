# config/initializers/solid_cable.rb
Rails.application.config.after_initialize do
  SolidCable.configure do |config|
    # Use the normal production DB instead of a separate :cable DB
    config.database = :production
  end
end