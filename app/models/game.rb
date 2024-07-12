# frozen_string_literal: true

class Game < ApplicationRecord
  has_many :releases, dependent: :destroy, autosave: true
  has_many :platforms, through: :releases, autosave: true

  has_and_belongs_to_many :genres, autosave: true

  validates :name, presence: { unless: :igdb_id }
  validates :igdb_id, numericality: { only_integer: true, greater_than: 0 }, uniqueness: true, allow_nil: true

  after_create :import_igdb_data

  private

  def import_igdb_data
    IGDB::ImportGameJob.perform_later(igdb_id)
  end
end
