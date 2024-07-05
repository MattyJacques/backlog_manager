# frozen_string_literal: true

class Genre < ApplicationRecord
  has_and_belongs_to_many :games

  validates :name, uniqueness: { case_sensitive: false }, allow_nil: true
  validates :slug, uniqueness: { case_sensitive: false }, allow_nil: true
  validates :igdb_id, presence: true, numericality: { only_integer: true }, uniqueness: true

  after_create :import_igdb_data

  private

  def import_igdb_data
    IGDB::Services::ImportGenre.import(igdb_id)
  end
end
