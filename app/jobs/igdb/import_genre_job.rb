# frozen_string_literal: true

module IGDB
  class ImportGenreJob < ApplicationJob
    queue_as :igdb

    def perform(igdb_id)
      Rails.logger.info("Importing genre from IGDB with ID: #{igdb_id}")

      IGDB::Services::ImportGenre.import(igdb_id)

      Rails.logger.info("Imported genre from IGDB with ID: #{igdb_id}")
    end
  end
end
