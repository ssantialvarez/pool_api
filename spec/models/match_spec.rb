require 'rails_helper'

RSpec.describe Match, type: :model do
  subject (:player1) {
    Player.create(
      name: "Jack",
      auth0_id: "auth0|123456",
      profile_picture_url: "https://pool-app-storage.s3.us-east-2.amazonaws.com/foto_de_perfil.jpg",
      ranking: 0
    )
  }
  subject (:player2) {
    Player.create(
      name: "Peter",
      auth0_id: "auth0|456789",
      profile_picture_url: "https://pool-app-storage.s3.us-east-2.amazonaws.com/foto_de_perfil.jpg",
      ranking: 0
    )
  }
  subject {
    Match.new(
      start_time: Time.now,
      player1_id: player1.id,
      player2_id: player2.id,
      table_number: 1,
      winner_id: nil
    )
  }

  it "is valid with valid attributes" do
    expect(subject).to be_valid
  end
  it "is not valid without a player 1" do
    subject.player1_id=nil
    expect(subject).to_not be_valid
  end
  it "is not valid without a player 2" do
    subject.player2_id=nil
    expect(subject).to_not be_valid
  end
  it "is not valid without a start time" do
    subject.start_time=nil
    expect(subject).to_not be_valid
  end

  # pending "add some examples to (or delete) #{__FILE__}"
end
