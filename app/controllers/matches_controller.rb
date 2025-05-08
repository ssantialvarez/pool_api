class MatchesController < ApplicationController
  before_action :authorize
  PLAYER_ID_CONFLICT = {
    message: "Player1 and Player2 cannot be the same."
  }.freeze
  DOUBLE_BOOKING = {
    error: "double_booking",
    error_description: "The match overlaps with another match of one of the players, or another match is scheduled on the same table.",
    message: "Double booking detected."
  }.freeze

  # Creates match.
  # Must provide player1_id, player2_id, start_time.
  # Optionally provide table_number.
  # If double-booking is detected, responds with 409 Conflict.
  # format ISO 8601 (YYYY-MM-DDTHH:MM:SSZ)
  def create
    end_time = params[:end_time]
    render json: DOUBLE_BOOKING, status: :conflict and return if
     checks_double_booking(params[:player1_id], params[:player2_id], params[:start_time], end_time, params[:table_number])
    render json: PLAYER_ID_CONFLICT, status: :conflict and return if params[:player1_id] == params[:player2_id]
    # Check if player1_id and player2_id are the same.


    match = Match.new do |m|
      m.player1_id = params[:player1_id]
      m.player2_id = params[:player2_id]
      m.start_time = params[:start_time]
      m.end_time = end_time.present? ? end_time : nil
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
    # status=upcoming|ongoing|completed – filter by status.
    status = params[:status]

    if status == "upcoming"
      matches = Match.where("start_time >= :start_time", { start_time: Time.now })
    elsif status == "ongoing"
      matches = Match.where("start_time < :start_time AND end_time IS NULL", { start_time: Time.now })
    elsif status == "completed"
      matches = Match.where("end_time IS NOT NULL")
    else
      matches = Match.all
    end

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
    render json: DOUBLE_BOOKING, status: :conflict and return if start_time.present? &&
      checks_double_booking(match.player1_id, match.player2_id, start_time, end_time, table_number)

    render json: PLAYER_ID_CONFLICT, status: :conflict and return if params[:player1_id] == params[:player2_id] && params[:player1_id].present?

    if winner_id.present?
      if winner_id == match.player1_id || winner_id == match.player2_id
        # Checks who won the match.
        # Updates ranking of the winner and loser.
        # For instance, ranking += 1 for each win.
        # ranking -= 1 for each loss.
        winner = Player.find(winner_id)
        loser = winner_id == match.player1_id ? match.player2 : match.player1
        winner.update(ranking: winner.ranking + 1)
        loser.update(ranking: loser.ranking - 1)
      else
        render json: {
          message: "Winner must be one of the players in the match."
        }, status: :conflict
        return
      end
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
    # Check if the match is ongoing.
    # Cannot delete an ongoing match.
    if match.start_time < Time.now && (match.end_time.nil? || match.end_time > Time.now)
      render json: {
        message: "Cannot delete an ongoing match."
      }, status: :conflict # 409 Conflict
      return
    end
    match.destroy
    # If the match is not found, it will raise an ActiveRecord::RecordNotFound exception.
    # This will be handled by the rescue_from in ApplicationController.
    # The exception will return a 404 Not Found response.
    # If the match is found, it will be deleted and a 200 OK response will be returned.
    render json: { message: "Deleting match #{params[:id]} admin only?" }
  end

  private

  def checks_double_booking(player1_id, player2_id, start_time, end_time = nil, table_number = nil)
    return false if start_time.blank? # Handle missing or empty start_time

    start_time = Time.parse(start_time.to_s) unless start_time.is_a?(Time)
    end_time = start_time + 1.hour if end_time.nil?
    end_time = Time.parse(end_time.to_s) unless end_time.is_a?(Time)
    previous_time = start_time - 1.hour

    matches = Match.where(
      player1_id: player1_id,
      start_time: previous_time..end_time
    ).or(Match.where(
      player2_id: player2_id,
      start_time: previous_time..end_time
    )).or(Match.where(
      table_number: table_number,
      start_time: previous_time..end_time
    ))

    !matches.empty?
  end
end
