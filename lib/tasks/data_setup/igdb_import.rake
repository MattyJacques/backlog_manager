# frozen_string_literal: true

namespace :data_setup do
  namespace :igdb_import do
    desc 'Import 100 games from IGDB'
    task games: :environment do
      CSV.read("#{File.dirname(__FILE__)}/../csvs/igdb_game_ids.csv").each_with_index do |row, i|
        print("\rImporting game #{i + 1} of 100")
        Game.create!(igdb_id: row[0])
      end

      puts ''
    end
  end
end
