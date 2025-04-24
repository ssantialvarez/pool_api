require 'rails_helper'

RSpec.describe Player, type: :model do
  subject {
    Player.new(
      name: "Jack",
      auth0_id: "auth0|123456",
      profile_picture_url: "https://pool-app-storage.s3.us-east-2.amazonaws.com/foto_de_perfil.jpg",
      ranking: 0
    )
  }
  it "is valid with valid attributes" do
    expect(subject).to be_valid
  end
  it "is not valid without a name" do
    subject.name=nil
    expect(subject).to_not be_valid
  end
  it "is not valid without an auth0_id" do
    subject.auth0_id=nil
    expect(subject).to_not be_valid
  end
  it "is not valid without a profile picture url" do
    subject.profile_picture_url=nil
    expect(subject).to_not be_valid
  end
  it "is not valid with negative ranking" do
    subject.ranking=-1
    expect(subject).to_not be_valid
  end
  # pending "add some examples to (or delete) #{__FILE__}"
end
