# frozen_string_literal: true

class Genre < ApplicationRecord
  has_and_belongs_to_many :games

  validates :igdb_id, presence: true, numericality: { only_integer: true }, uniqueness: true
end
