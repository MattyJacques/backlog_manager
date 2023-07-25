# frozen_string_literal: true

module PSN
  class ScrapePSNProfileJob < ApplicationJob
    queue_as :PSN

    def perform(psn_id, trophy_lists)
      psnp_ids = Spiders::PSNProfilesSpider.process(psn_id)
      match_psnp_ids(trophy_lists, psnp_ids) if psnp_ids.present?
    end

    private

    def match_psnp_ids(lists, psnp_ids)
      # Sort the list ids as the DB will load in ID order
      lists.each_with_index do |trophy_list, index|
        next unless trophy_list.psnp_id.nil?

        psnp_id = psnp_ids[index]
        update_list(trophy_list, psnp_id) if psnp_id.present?
      end

      Rails.logger.info('Matched lists to PSNP')
    end

    def update_list(trophy_list, psnp_id)
      Rails.logger.info("Matched #{trophy_list.name} to #{psnp_id[:name]}")

      trophy_list.update!(psnp_id: psnp_id[:psnp_id])
      trophy_list.releases.first.game.update!(name: psnp_id[:name])
    end
  end
end
