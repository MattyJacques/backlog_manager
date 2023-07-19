# frozen_string_literal: true

class Game < ApplicationRecord
  has_many :platforms, through: :releases
  has_many :releases, dependent: :destroy
  has_many :trophy_lists, through: :releases

  validates :name, presence: true
  validates :igdb_id, numericality: { only_integer: true }, uniqueness: true, allow_nil: true
  validates :how_long_to_beat_id, numericality: { only_integer: true }, uniqueness: true, allow_nil: true
end
