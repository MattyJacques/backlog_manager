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

    desc 'Import genres from IGDB'
    task genres: :environment do
      1.upto(100).each do |i|
        IGDB::ImportGenreJob.perform_now(i)
        sleep(0.5)
      rescue StandardError
        puts "Error importing genre with ID: #{i}"
      end

      puts ''
    end

    desc 'Import platforms from IGDB'
    task platforms: :environment do
      CSV.read("#{File.dirname(__FILE__)}/../csvs/igdb_platform_ids.csv").each do |row|
        print("Importing platform #{row[0]}\n")
        IGDB::ImportPlatformJob.perform_now(row[0])
      rescue StandardError => e
        Rails.logger.error("Error importing platform with ID: #{row[0]} - error: #{e}")
      end

      puts ''
    end
  end
end
