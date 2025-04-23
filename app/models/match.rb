class Match < ApplicationRecord
  validates :start_time, presence: true
  validates :table_number, numericality: { only_integer: true, greater_than_or_equal_to: 0 }, allow_nil: true

  belongs_to :player1, class_name: "Player"
  belongs_to :player2, class_name: "Player"
  belongs_to :winner, class_name: "Player", optional: true
end
