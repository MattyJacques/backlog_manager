# frozen_string_literal: true

module PSN
  class Trophy
    PSN_TITLE_LIMIT = 800

    class << self
      # Get a list of all accounts synced to account
      def all_titles_for_account(account_id)
        Rails.logger.info("Retrieving titles synced to #{account_id}")

        titles = []
        offset = 0

        loop do
          response = PSN::API::Trophy.account_titles(account_id, offset:, limit: PSN_TITLE_LIMIT)
          titles.push(*response['trophyTitles'])

          break if response['nextOffset'].nil?

          offset += PSN_TITLE_LIMIT
        end

        Rails.logger.info("Retrieved #{titles.count} titles for #{account_id}")

        titles
      end

      # Get all trophies within a title's trophy list
      def title_trophy_list(communication_id, service_name)
        Rails.logger.info("Retrieving trophy list for title #{communication_id}, using #{service_name} service")

        PSN::API::Trophy.title_trophy_list(communication_id, service_name)['trophies']
      end

      # Get earned trophies for a title for the given account
      def earned_trophies_for_title(communication_id, service_name, account_id)
        Rails.logger.info(
          "Retrieving earned trophies for title #{communication_id} for #{account_id} using #{service_name} service"
        )

        PSN::API::Trophy.title_trophy_list(communication_id, service_name, account_id)['trophies']
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
        all_titles_for_account(account_id).filter { |title| title['progress'].positive? }
      end
    end
  end
end
