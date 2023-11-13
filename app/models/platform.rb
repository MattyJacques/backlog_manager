# frozen_string_literal: true

class Platform < ApplicationRecord
  belongs_to :platform_family, optional: true
  has_many :releases, dependent: :destroy
  has_many :games, through: :releases

  validates :name, presence: true, uniqueness: { case_sensitive: false }
  validates :igdb_id, numericality: { only_integer: true }, uniqueness: true, allow_nil: true
end
