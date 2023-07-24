# frozen_string_literal: true

module PSN
  module Services
    class ImportAccountDefinedTrophies
      class << self
        def import(account_id)
          Rails.logger.info("Importing defined trophies on #{account_id}")

          titles = PSN::Client::Trophy.all_account_titles(account_id)

          Rails.logger.info("Retrieved #{titles.count} titles")

          titles&.each { |title| import_title(title) }
        end

        private

        def import_title(title)
          ActiveRecord::Base.transaction do
            PSN::Services::ImportPSNRelease.import(title) unless list_exists?(title['npCommunicationId'])
          end
        end

        def list_exists?(comm_id)
          TrophyList.exists?(comm_id:)
        end
      end
    end
  end
end
