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
            unless TrophyList.exists?(communication_id: title['npCommunicationId'])
              PSN::Services::ImportPSNRelease.import(title['trophyTitleName'],
                                                     title['trophyTitleDetail'],
                                                     title['npCommunicationId'],
                                                     title['npServiceName'],
                                                     title['trophyTitlePlatform'])
            end
          end
        end
      end
    end
  end
end
