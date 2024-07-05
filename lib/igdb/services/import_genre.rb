# frozen_string_literal: true

module IGDB
  module Services
    class ImportGenre
      class << self
        delegate :import, to: :new
      end

      def import(igdb_id)
        result = IGDB::Client::Genres.get_by_id(igdb_id)

        genre = Genre.find_or_initialize_by(igdb_id:)
        genre.update!(name: result['name'], slug: result['slug'])
      end
    end
  end
end
