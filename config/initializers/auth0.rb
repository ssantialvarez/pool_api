# ./config/initializers/auth0.rb
AUTH0_CONFIG = Rails.application.config_for(:auth0)
Rails.configuration.auth0 = ActiveSupport::InheritableOptions.new(AUTH0_CONFIG)
