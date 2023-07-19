# frozen_string_literal: true

class Platform < ApplicationRecord
  has_many :releases, dependent: :destroy
  has_many :games, through: :releases
  belongs_to :platform_family, optional: true

  validates :name, presence: true, uniqueness: { case_sensitive: false }
  validates :igdb_id, numericality: { only_integer: true }, uniqueness: true, allow_nil: true
end
