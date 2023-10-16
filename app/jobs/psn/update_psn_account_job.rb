# frozen_string_literal: true

module PSN
  class UpdatePSNAccountJob < ApplicationJob
    queue_as :PSN

    def perform(psn_account_id, should_scrape: false)
      account = PSNAccount.find(psn_account_id)

      logger.info("Updating trophies for #{account.psn_id}")

      import_psn_account(account) if account.account_id.blank?

      trophy_lists = import_defined_trophies(account.account_id)
      import_earned_trophies(account.account_id)

      PSN::ScrapeProfileJob.perform_now(account.psn_id, trophy_lists) if should_scrape

      logger.info("Updated trophies for #{account.psn_id}")
    end

    private

    def import_psn_account(account)
      profile = PSN::Client::User.get_profile_from_username(account.psn_id)

      account.update!(psn_id: profile['onlineId'],
                      account_id: profile['accountId'],
                      avatar: profile['avatarUrls'].first['avatarUrl'],
                      plus: profile['plus'],
                      about_me: profile['aboutMe'])
    end

    def import_defined_trophies(account_id)
      logger.info('Importing defined torphies')

      PSN::Services::ImportAccountDefinedTrophies.import(account_id)
    end

    def import_earned_trophies(account_id)
      logger.info('Updating earned trophies')

      PSN::Services::UpdateAccountEarnedTrophies.update(account_id)
    end
  end
end
