# frozen_string_literal: true

module IGDB
  class ImportPlatformJob < ApplicationJob
    queue_as :igdb

    def perform(igdb_id)
      Rails.logger.info("Importing platform from IGDB with ID: #{igdb_id}")

      IGDB::Services::ImportPlatform.import(igdb_id)

      Rails.logger.info("Imported platform from IGDB with ID: #{igdb_id}")
    end
  end
end
