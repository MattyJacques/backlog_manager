# frozen_string_literal: true

class Release < ApplicationRecord
  enum region: { europe: 1, north_america: 2, australia: 3, new_zealand: 4,
                 japan: 5, china: 6, asia: 7, worldwide: 8, korea: 9, brazil: 10 }, _prefix: true

  belongs_to :game
  belongs_to :platform

  validates :igdb_id, presence: true, numericality: { only_integer: true }, uniqueness: true
end
