# frozen_string_literal: true

module Spiders
  class PSNTLProfileSpider < Spiders::Base
    @name = 'psn_trophy_leaders_profile'
    @engine = :mechanize

    def self.process(psn_id)
      Rails.logger.info("Scraping PSNTL profile for PSN ID: #{psn_id}")

      parse!(:parse, url: "https://psntrophyleaders.com/user/view/#{psn_id}")
    end

    def parse(response, url:, data: {})
      games = response.css('#usergamelist tr.gamerow')

      result = games&.map do |game|
        node = game.css('td')
        {
          id: node.first.text,
          date: node[2].text
        }
      end

      result.sort_by! { |g| g[:date].to_datetime }.reverse!
    end
  end
end
