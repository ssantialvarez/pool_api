class PlayersController < ApplicationController
  before_action :authorize

  def private
    render json: { message: "Hello from a private endpoint! You need to be authenticated to see this." }
  end

  def private_scoped
    validate_permissions [ "admin" ] do
      render json: { message: "Hello from a private endpoint! You need to be authenticated and have a scope of admin to see this." }
    end
  end
end
