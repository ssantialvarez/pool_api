require 'rails_helper'

RSpec.describe "Matches", type: :request do
  describe "POST /matches" do
    before do
      # Stub methods
      allow_any_instance_of(ApplicationController).to receive(:authorize).and_return(true)
      allow_any_instance_of(ApplicationController).to receive(:validate_permissions).and_yield
    end
    let!(:player1) { Player.create!(name: "Doe", auth0_id: "auth0|1234567890", profile_picture_url: "https://example.com/player1.jpg") }
    let!(:player2) { Player.create!(name: "John", auth0_id: "auth0|0987654321", profile_picture_url: "https://example.com/player2.jpg") }
    it "creates a match" do
      post matches_path, params: {
        player1_id:  player1.id,
        player2_id: player2.id,
        start_time: Time.now.iso8601, # Use ISO 8601 format
        table_number: 1
      }

      expect(response).to have_http_status(:created)
    end
    it "returns a conflict for double booking" do
      # Create a match first
      post matches_path, params: {
        player1_id:  player1.id,
        player2_id: player2.id,
        start_time: Time.now.iso8601,
        table_number: 1
      }

      # Try to create a conflicting match
      post matches_path, params: {
        player1_id:  player1.id,
        player2_id: player2.id,
        start_time: Time.now.iso8601,
        end_time: Time.now.iso8601,
        table_number: 1
      }

      expect(response).to have_http_status(:conflict)
    end
  end
end
