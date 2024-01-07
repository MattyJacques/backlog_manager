# frozen_string_literal: true

class Genre < ApplicationRecord
  has_and_belongs_to_many :games

  after_create :import_igdb_genre

  private

  def import_igdb_genre
    return if name.present?

    IGDB::ImportGenreJob.perform_later(igdb_id)
  end
end
