class Player < ApplicationRecord
  validates :profile_picture_url, presence: true
  validates :auth0_id, presence: true
  validates :name, presence: true
  validates :ranking, numericality: { only_integer: true, greater_than_or_equal_to: 0 }, allow_nil: true

  has_one_attached :profile_picture
  has_many :matches_as_player1, class_name: "Match", foreign_key: "player1_id", dependent: :delete_all
  has_many :matches_as_player2, class_name: "Match", foreign_key: "player2_id", dependent: :delete_all
  has_many :wins, class_name: "Match", foreign_key: "winner_id"

  before_save :default_values
  def default_values
    # self.status ||= 'P' # note self.status = 'P' if self.status.nil? might better for boolean fields (per @frontendbeauty)
    self.ranking = 0 if self.ranking.nil?
  end
end
