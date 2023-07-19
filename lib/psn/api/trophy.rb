# frozen_string_literal: true

module PSN
  module API
    class Trophy
      class << self
        # Get earned trophies for a title for the given account
        def earned_trophies_for_title(communication_id, service_name, account_id)
          Rails.logger.info(
            "Retrieving earned trophies for title #{communication_id} for #{account_id} using #{service_name} service"
          )

          PSN::Client::Trophy.title_trophy_list(communication_id, service_name, account_id)['trophies']
        end

        def trophy_streak(account_id)
          trophies = all_trophies(account_id)

          timestamps = trophies.map do |trophy|
            DateTime.parse(trophy['earnedDateTime'])
          end

          dates = timestamps.map(&:to_date).uniq!.sort!.reverse!
          no_trophy_dates = []
          '2008/07/02'.to_date.upto(Time.zone.today) do |date|
            no_trophy_dates << date unless dates.include?(date)
          end

          no_trophy_dates
        end

        def all_trophies(account_id)
          Rails.logger.info("Retrieving all trophies for #{account_id}")

          titles = titles_for_account_with_earned(account_id)
          trophies = titles.map do |title|
            title_trophies = earned_trophies_for_title(title['npCommunicationId'],
                                                       title['npServiceName'],
                                                       account_id)
            title_trophies.filter { |trophy| trophy['earnedDateTime'].present? }
          end

          trophies.flatten!

          Rails.logger.info("Retrieved #{trophies.count} trophies for #{account_id}")

          trophies
        end

        private

        # Get all the titles synced to the account with at least one earned trophy
        def titles_for_account_with_earned(account_id)
          PSN::Client::Trophy.all_account_titles(account_id).filter { |title| title['progress'].positive? }
        end
      end
    end
  end
end
