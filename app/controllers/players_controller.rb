class PlayersController < ApplicationController
  before_action :authorize

  def show
    render json: { message: "Showing users info." }
  end

  def update
    render json: { message: "Updating user." }
  end

  def index
    validate_permissions [ "admin" ] do
      render json: { message: "Showing all players admin only." }
    end
  end

  def create
    validate_permissions [ "admin" ] do
      render json: { message: "Creating player admin only." }
    end
  end

  def destroy
    validate_permissions [ "admin" ] do
      render json: { message: "Destroying user admin only" }
    end
  end
end
