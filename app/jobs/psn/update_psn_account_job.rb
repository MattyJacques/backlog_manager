# frozen_string_literal: true

module PSN
  class UpdatePSNAccountJob < ApplicationJob
    queue_as :PSN

    def perform(psn_id)
      Rails.logger.info("Updating trophies for #{psn_id}")

      account = import_psn_account(psn_id)

      PSN::Services::ImportAccountDefinedTrophies.import(account.account_id)

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
  end
end
