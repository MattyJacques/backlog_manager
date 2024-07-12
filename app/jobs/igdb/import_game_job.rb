# frozen_string_literal: true

module IGDB
  class ImportGameJob < ApplicationJob
    queue_as :igdb

    def perform(igdb_id)
      Rails.logger.info("Importing game from IGDB with ID: #{igdb_id}")

      IGDB::Services::ImportGame.import(igdb_id)

      Rails.logger.info("Imported game from IGDB with ID: #{igdb_id}")
    end
  end
end
