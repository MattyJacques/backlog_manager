# frozen_string_literal: true

module PSN
  module Services
    class UpdateAccountEarnedTrophies
      class << self
        def update(account_id)
          Rails.logger.info("Updating earned trophies for #{account_id}")

          account = PSNAccount.find_by!(account_id:)
          titles = PSN::Client::Trophy.all_account_titles(account_id)

          Rails.logger.info("Retrieved #{titles.count} titles")

          titles&.each do |title|
            ActiveRecord::Base.transaction do
              update_title(account, title)
            end
          end
        end

        private

        def update_title(psn_account, title)
          earned_data = PSN::Client::Trophy.title_trophy_list(title['npCommunicationId'],
                                                              title['npServiceName'],
                                                              psn_account.account_id)
          trophy_list = TrophyList.find_by!(communication_id: title['npCommunicationId'])
          account_trophy_list = AccountTrophyList.find_by(psn_account:, trophy_list:)
          list_updated_at = account_trophy_list&.updated_at

          update_account_trophy_list(account_trophy_list, psn_account, trophy_list)

          return unless list_updated_at.nil? || list_updated_at < title['lastUpdatedDateTime'].to_datetime

          update_earned_trophies(psn_account, trophy_list, earned_data)
        end

        def update_account_trophy_list(account_trophy_list, psn_account, trophy_list)
          if account_trophy_list.present?
            account_trophy_list.touch # rubocop:disable Rails/SkipsModelValidations
          else
            AccountTrophyList.create!(psn_account:, trophy_list:)
          end
        end

        def update_earned_trophies(psn_account, trophy_list, earned_data)
          earned_trophies(earned_data).each do |earned_trophy|
            trophy = trophy_list.trophies.find_by!(psn_id: earned_trophy['trophyId'])
            timestamp = earned_trophy['earnedDateTime']

            next unless can_update_trophy(psn_account, trophy, timestamp)

            if psn_account.earned_trophies.exists?(trophy:)
              psn_account.earned_trophies.find_by!(trophy:).update!(timestamp:)
            else
              EarnedTrophy.create!(psn_account:, trophy_list:, trophy:, timestamp:)
            end
          end
        end

        def earned_trophies(earned_data)
          earned_data['trophies'].select { |t| t['earnedDateTime'].present? }
        end

        def can_update_trophy(psn_account, trophy, timestamp)
          timestamp.present? &&
            !psn_account.earned_trophies.exists?(trophy:, timestamp:)
        end
      end
    end
  end
end
