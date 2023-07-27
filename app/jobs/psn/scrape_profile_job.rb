# frozen_string_literal: true

module PSN
  class ScrapeProfileJob < ApplicationJob
    queue_as :PSN

    def perform(psn_id, trophy_lists)
      psnp_ids = Spiders::PSNPProfileSpider.process(psn_id)
      psntl_ids = Spiders::PSNTLProfileSpider.process(psn_id)

      Rails.logger.info(
        "Obtained #{psnp_ids.count} IDs from PSNP and #{psntl_ids.count} IDs from PSNTL for #{psn_id}"
      )

      match_ids(trophy_lists, psnp_ids, psntl_ids) if psnp_ids.present? || psntl_ids.present?
    end

    private

    def match_ids(lists, psnp_ids, psntl_ids)
      # Sort the list ids as the DB will load in ID order
      lists.each_with_index do |trophy_list, index|
        next unless trophy_list.psnp_id.nil? || trophy_list.psntl_id.nil?

        psnp_id = psnp_ids[index]
        psntl_id = psntl_ids[index]
        update_list(trophy_list, psnp_id, psntl_id) if psnp_id.present? || psntl_id.present?
      end

      Rails.logger.info('Matched lists to PSNP/PSNTL')
    end

    def update_list(trophy_list, psnp_id, psntl_id)
      Rails.logger.info(
        "Matched #{trophy_list.name} to PSNP: #{psnp_id&.[](:psnp_id)} and PSNTL: #{psntl_id&.[](:id)}"
      )

      trophy_list.update!(psnp_id: psnp_id&.[](:psnp_id) || trophy_list.psnp_id,
                          psntl_id: psntl_id&.[](:id) || trophy_list.psntl_id)
      trophy_list.releases.first.game.update!(name: psnp_id[:name]) if psnp_id&.[](:name).present?
    end
  end
end
