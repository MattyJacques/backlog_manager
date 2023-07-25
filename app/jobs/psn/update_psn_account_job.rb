# frozen_string_literal: true

module PSN
  class UpdatePSNAccountJob < ApplicationJob
    queue_as :PSN

    def perform(psn_id, should_scrape: false)
      Rails.logger.info("Updating trophies for #{psn_id}")

      account = PSNAccount.find_by(psn_id:) || import_psn_account(psn_id)

      list_ids = import_defined_trophies(account.account_id)
      import_earned_trophies(account.account_id)

      PSN::ScrapePSNProfileJob.perform_now(psn_id, list_ids) if should_scrape

      Rails.logger.info("Updated trophies for #{psn_id}")
    end

    private

    def import_psn_account(psn_id)
      profile = PSN::Client::User.get_profile_from_username(psn_id)

      PSNAccount.create(psn_id: profile['onlineId'],
                        account_id: profile['accountId'],
                        avatar: profile['avatarUrls'].first['avatarUrl'],
                        plus: profile['plus'],
                        about_me: profile['aboutMe'])
    end

    def import_defined_trophies(account_id)
      Rails.logger.info('Importing defined torphies')

      PSN::Services::ImportAccountDefinedTrophies.import(account_id)
    end

    def import_earned_trophies(account_id)
      Rails.logger.info('Updating earned trophies')

      PSN::Services::UpdateAccountEarnedTrophies.update(account_id)
    end
  end
end
