# frozen_string_literal: true

module PSN
  module Services
    class UpdateAccountTitle
      class << self
        def update(psn_account, title)
          trophy_list = TrophyList.find_by!(comm_id: title['npCommunicationId'])
          account_trophy_list = AccountTrophyList.find_or_initialize_by(psn_account:, trophy_list:)

          return unless account_trophy_list.psn_updated_at.nil? ||
                        account_trophy_list.psn_updated_at < title['lastUpdatedDateTime'].to_datetime

          earned_data = PSN::Client::Trophy.title_trophy_list(title['npCommunicationId'],
                                                              title['npServiceName'],
                                                              psn_account.account_id)
          update_earned_data(account_trophy_list, trophy_list, title, earned_data)
        end

        private

        def update_earned_data(account_trophy_list, trophy_list, title_data, earned_data)
          ActiveRecord::Base.transaction do
            update_account_data(account_trophy_list, title_data)
            update_earned_trophies(account_trophy_list, trophy_list, earned_data)
          end
        end

        def update_earned_trophies(account_trophy_list, trophy_list, earned_data)
          earned_trophies(earned_data).each do |earned_trophy|
            trophy = trophy_list.trophies.find_by!(psn_id: earned_trophy['trophyId'])

            next unless can_update_trophy(account_trophy_list, trophy, earned_trophy)

            if account_trophy_list.earned_trophies.exists?(trophy:)
              account_trophy_list.earned_trophies.find_by!(trophy:).update!(timestamp: earned_trophy['earnedDateTime'])
            else
              EarnedTrophy.create!(account_trophy_list:, trophy:, timestamp: earned_trophy['earnedDateTime'])
            end
          end
        end

        def update_account_data(account_trophy_list, earned_data)
          account_trophy_list.update!(earned_bronze: earned_data['earnedTrophies']['bronze'],
                                      earned_silver: earned_data['earnedTrophies']['silver'],
                                      earned_gold: earned_data['earnedTrophies']['gold'],
                                      earned_platinum: earned_data['earnedTrophies']['platinum'],
                                      psn_updated_at: earned_data['lastUpdatedDateTime'].to_datetime)
        end

        def earned_trophies(earned_data)
          earned_data['trophies'].select { |t| t['earned'] }
        end

        def can_update_trophy(account_list, trophy, earned_data)
          earned_data['earned'] &&
            !account_list.earned_trophies.exists?(trophy:, timestamp: earned_data['earnedDateTime'])
        end
      end
    end
  end
end
