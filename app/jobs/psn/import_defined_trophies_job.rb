# frozen_string_literal: true

module PSN
  class ImportDefinedTrophiesJob < ApplicationJob
    queue_as :PSN

    def perform(psn_id, should_scrape: false)
      account_id = account_id_from_psn_id(psn_id)

      Rails.logger.info('Importing defined torphies')

      trophy_list_ids = PSN::Services::ImportAccountDefinedTrophies.import(account_id)

      PSN::ScrapePSNProfileJob.perform_now(psn_id, trophy_list_ids) if should_scrape

      Rails.logger.info("Imported trophies from #{psn_id}")
    end

    private

    def account_id_from_psn_id(psn_id)
      PSNAccount.find_by(psn_id:) || PSN::Client::User.get_profile_from_username(psn_id)['accountId']
    end
  end
end
