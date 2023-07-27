# frozen_string_literal: true

module Spiders
  class PSNTLUnobtainableDatesSpider < Spiders::Base
    @name = 'psntl_unobtainable_dates'
    @engine = :mechanize

    def self.process(psntl_ids)
      Rails.logger.info('Scraping PSNTL unobtainable dates')

      @start_urls = psntl_ids.map { |psntl_id| "https://psntrophyleaders.com/game/view/#{psntl_id}" }
      crawl!
    end

    def parse(response, url:, data: {})
      Rails.logger.info { "Crawling: #{url}" }

      date_string = response.xpath('//*[contains(text(), "No longer possible")]')&.first&.text
      update_list(url, date_string) if date_string.present?
    end

    private

    def update_list(url, date_string)
      parsed_date = date_string[/No longer possible as of (.*?): /m, 1]
      psntl_id = url.split('/').last

      trophy_list = TrophyList.find_by!(psntl_id:)
      trophy_list.update!(server_shutdown_date: parsed_date.to_date)
    end
  end
end
