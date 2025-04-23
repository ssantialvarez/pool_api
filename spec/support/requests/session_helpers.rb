module Requests
  module SessionHelpers
    def log_in(user, invalid = false, strategy = :auth0)
      invalid ?  mock_invalid_auth_hash : mock_valid_auth_hash(user)
      Rails.application.env_config["omniauth.auth"] = OmniAuth.config.mock_auth[strategy.to_sym]
      visit "/auth/#{strategy}/callback?code=vihipkGaumc5IVgs"
    end
  end
end
