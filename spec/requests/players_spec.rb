require 'rails_helper'

RSpec.describe "Players", type: :request do
  before do
    # Stub methods
    allow_any_instance_of(ApplicationController).to receive(:authorize).and_return(true)
    allow_any_instance_of(ApplicationController).to receive(:validate_permissions).and_yield

    # Create test players
    Player.create!(name: "Doe", auth0_id: "auth0|1234567890", profile_picture_url: "https://example.com/player1.jpg")
    Player.create!(name: "John", auth0_id: "auth0|0987654321", profile_picture_url: "https://example.com/player2.jpg")
  end
  describe "GET /players" do
    it "returns all players" do
      get players_path

      expect(response).to have_http_status(:success)
      expect(response.body).to include("John")
      expect(response.body).to include("Doe")
    end
    it "filters players by name" do
      get players_path, params: { name: "Doe" }

      expect(response).to have_http_status(:success)
      expect(response.body).to include("Doe")
      expect(response.body).not_to include("John")
    end
  end
end
