auth0_config = Rails.application.config_for(:auth0)
Rails.configuration.auth0 = ActiveSupport::InheritableOptions.new(auth0_config)
