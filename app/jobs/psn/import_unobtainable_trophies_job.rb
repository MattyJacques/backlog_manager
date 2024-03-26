# frozen_string_literal: true

module PSN
  class ImportUnobtainableTrophiesJob < ApplicationJob
    PSNP_LIST_URL = 'https://psnp-plus.huskycode.dev/list.min.json'

    queue_as :PSN

    def perform
      psntl_ids = TrophyList.where.not(psntl_id: nil).where(server_shutdown_date: nil).pluck(:psntl_id)
      Spiders::PSNTLUnobtainableDatesSpider.process(psntl_ids)

      response = HTTParty.get(PSNP_LIST_URL)

      raise "PSNP+ returned an error: #{response}" unless response.success?

      Rails.logger.debug { "PSNP+ response: #{response}" }

      parse_lists(response['list'])

      Rails.logger.info('Updated unobtainable trophies')
    end

    private

    def parse_lists(unobtainable_ids)
      lists = TrophyList.where(psnp_id: unobtainable_ids.keys)

      lists.each { |list| update_list(list, unobtainable_ids[list.psnp_id]) }
    end

    def update_list(list, trophy_ids)
      ActiveRecord::Base.transaction do
        if trophy_ids == [0]
          list.trophies.update!(unobtainable: true)
        else
          # PSNP ids are one above what they are on PSN
          psn_trophy_ids = trophy_ids.map { |id| id - 1 }
          list.trophies.where(psn_id: psn_trophy_ids).update!(unobtainable: true)
        end
      end
    end
  end
end
