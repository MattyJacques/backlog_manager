# frozen_string_literal: true

module PSN
  module Services
    class UpdateAccountEarnedTrophies
      class << self
        def update(account_id)
          new(account_id).update
        end
      end

      def initialize(account_id)
        @account = PSNAccount.find_by!(account_id:)
      end

      def update
        Rails.logger.info("Updating earned trophies for #{@account.psn_id}")

        if should_update
          update_trophy_counts

          titles = PSN::Client::Trophy.all_account_titles(@account.account_id)

          Rails.logger.info("Retrieved #{titles.count} titles")

          update_titles(titles)

          Rails.logger.info("Updated earned trophies for #{@account.psn_id}")
        else
          Rails.logger.info('Update not needed')
        end
      end

      private

      def should_update
        trophy_count_increased? || title_count_increased?
      end

      def trophy_count_increased?
        @account.earned_trophies.count < (earned_trophy_counts&.values&.sum || 0)
      end

      def title_count_increased?
        @account.account_trophy_lists.count <
          PSN::Client::Trophy.account_title_count(@account.account_id)
      end

      def update_trophy_counts
        @account.update!(earned_bronze: earned_trophy_counts['bronze'],
                         earned_silver: earned_trophy_counts['silver'],
                         earned_gold: earned_trophy_counts['gold'],
                         earned_platinum: earned_trophy_counts['platinum'])
      end

      def update_titles(titles)
        titles&.each { |title| PSN::Services::UpdateAccountTitle.update(@account, title) }
      end

      def earned_trophy_counts
        @earned_trophy_counts ||= PSN::Client::Trophy.account_summary(@account.account_id)['earnedTrophies']
      end
    end
  end
end
