# frozen_string_literal: true

module IGDB
  module Client
    class Games < Base
      ENDPOINT = 'games'

      # Search IGDB for a game with the given title
      def self.search(title, limit = 20)
        return if title.blank?

        params = { fields: 'name, platforms.name, genres.name' }
        params[:search] = "\"#{title}\""
        params[:limit] = limit
        post(ENDPOINT, params)
      end
    end
  end
end
