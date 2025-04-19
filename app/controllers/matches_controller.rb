class MatchesController < ApplicationController
  before_action :authorize
  # Creates match.
  # Must provide player1_id, player2_id, start_time.
  # Optionally provide table_number.
  # If double-booking is detected, responds with 409 Conflict.
  # format ISO 8601 (YYYY-MM-DDTHH:MM:SSZ)
  def create
    if checks_double_booking(params[:player1_id], params[:player2_id], params[:start_time])
      render json: {
        message: "Double booking detected."
      }, status: :conflict # 409 Conflict
      return
    end
    # Check if player1_id and player2_id are the same.
    if params[:player1_id] == params[:player2_id]
      render json: {
        message: "Player1 and Player2 cannot be the same."
      }, status: :conflict
      return
    end

    match = Match.new do |m|
      m.player1_id = params[:player1_id]
      m.player2_id = params[:player2_id]
      m.start_time = params[:start_time]
      m.table_number = params[:table_number]
    end

    if match.save
      render json: match, status: :created  # 201 Created
    else
      render json: { errors: match.errors.full_messages }, status: :bad_request  # 400 Bad Request
    end
  end

  # Get details of a single match by id.
  def show
    match = Match.find(params[:id])
    render json: match
  end

  def index
    matches = Match.all
    render json: matches
  end

  # Update match details.
  # Can set end_time, winner_id, table_number, etc.
  # Checks again for double-booking if start_time changes.
  def update
    id = params[:id]
    start_time = params[:start_time]
    end_time = params[:end_time]
    winner_id = params[:winner_id]
    table_number = params[:table_number]

    match = Match.find(id)
    if start_time.present? && checks_double_booking(match.player1_id, match.player2_id, start_time)
      render json: {
        message: "Double booking detected."
      }, status: :conflict # 409 Conflict
      return
    end
    if params[:player1_id] == params[:player2_id]
      render json: {
        message: "Player1 and Player2 cannot be the same."
      }, status: :conflict
      return
    end
    match.update(
      start_time: start_time.present? ? start_time : match.start_time,
      end_time: end_time,
      winner_id: winner_id,
      table_number: table_number
    )
    render json: match
  end

  def destroy
    match = Match.find(params[:id])
    match.destroy
    # If the match is not found, it will raise an ActiveRecord::RecordNotFound exception.
    # This will be handled by the rescue_from in ApplicationController.
    # The exception will return a 404 Not Found response.
    # If the match is found, it will be deleted and a 200 OK response will be returned.
    render json: { message: "Deleting match #{params[:id]} admin only?" }
  end

  private

  def checks_double_booking(player1_id, player2_id, start_time)
    start_time = Time.parse(start_time.to_s) unless start_time.is_a?(Time)
    end_time = start_time + 1.hour
    previous_time = start_time - 1.hour

    matches_player1 = Match.where(
      player1_id: player1_id,
      start_time: previous_time..end_time
    )

    matches_player2 = Match.where(
      player2_id: player2_id,
      start_time: previous_time..end_time
    )

    !matches_player1.empty? || !matches_player2.empty?
  end
end
