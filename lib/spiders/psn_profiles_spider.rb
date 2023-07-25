# frozen_string_literal: true

module Spiders
  class PSNProfilesSpider < Spiders::Base
    @name = 'psn_profiles_spider'
    @engine = :mechanize

    def self.process(psn_id)
      Rails.logger.info("Scraping PSNProfile for PSN ID: #{psn_id}")

      games = []
      page_num = 1

      loop do
        new_games = parse!(:parse, url: "https://psnprofiles.com/#{psn_id}?completion=all&order=last-played&pf=all&page=#{page_num}")

        break if new_games.count == 1 # There is always at least one empty element

        games << new_games
        page_num += 1
      end

      games.flatten!.compact!
    end

    def parse(response, url:, data: {})
      games = response.css('//*[@id="gamesTable"] tr')

      games&.map do |game|
        title_node = game.css('a.title')
        if title_node&.attribute('href')&.value&.gsub!('/trophies/', '').present?
          psnp_id = title_node.attribute('href').value.gsub!('/trophies/', '').split('/').first

          {
            psnp_id:,
            name: title_node.text
          }
        end
      end
    end
  end
end
