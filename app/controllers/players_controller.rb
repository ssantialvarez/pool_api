class PlayersController < ApplicationController
  before_action :authorize

  # Shows the authenticated user's info.
  # It uses the already decoded token to look for the user by auth0_id.
  def show
    player = Player.find_by(auth0_id: @decoded_token[0][0]["sub"])

    render json: player
  end

  # Updates user's name and profile picture.
  # It uses the already decoded token to look for the user by auth0_id.
  def update
    name = params[:name]
    profile_picture = params[:profile_picture]
    player = Player.find_by(auth0_id: @decoded_token[0][0]["sub"])
    if profile_picture.present?
      player.profile_picture.attach(params[:profile_picture])
      profile_picture_url = url_for(player.profile_picture)
    end

    player.update(
      name: name.present? ? name : player.name,
      profile_picture_url: profile_picture_url.present? ? profile_picture_url : player.profile_picture_url
    )
    render json: player
  end

  # The following methods validate if the user's an admin by the scope "admin".
  # Retrieves all players.
  # Allow optional filtering by name  as query param.
  def index
    validate_permissions [ "admin" ] do
      players = Player.where("name LIKE ?",
        Player.sanitize_sql_like(params[:name]) + "%")
      render json: players
    end
  end

  # Creates player.
  def create
    validate_permissions [ "admin" ] do
      player = Player.new do |p|
        p.auth0_id = params[:auth0_id]
        p.name = params[:name]
        p.profile_picture_url = "https://pool-app-storage.s3.us-east-2.amazonaws.com/foto_de_perfil.jpg"
      end
      player.profile_picture.attach(params[:profile_picture])
      if player.save
        player.update(profile_picture_url: url_for(player.profile_picture))
        render json: player, status: :created  # 201 Created
      else
        render json: { errors: player.errors.full_messages }, status: :unprocessable_entity  # 422
      end
    end
  end

  # Deletes player by id, not by auth0_id.
  def destroy
    validate_permissions [ "admin" ] do
      id = params[:id]
      Player.destroy_by(id: id)
      render json: { message: "Deleting user #{id} admin only" }
    end
  end
end
