# frozen_string_literal: true

class Game < ApplicationRecord
  validates :name, presence: true
  validates :igdb_id, numericality: { only_integer: true }, uniqueness: true, allow_nil: true
end
