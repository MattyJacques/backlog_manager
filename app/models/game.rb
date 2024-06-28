# frozen_string_literal: true

class Game < ApplicationRecord
  has_and_belongs_to_many :genres, autosave: true

  validates :name, presence: true
  validates :igdb_id, numericality: { only_integer: true }, uniqueness: true, allow_nil: true
end
