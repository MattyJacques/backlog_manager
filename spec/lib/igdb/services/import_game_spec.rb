# frozen_string_literal: true

require 'rails_helper'

RSpec.describe IGDB::Services::ImportGame do
  describe '.import' do
    let(:game) { Game.new(igdb_id: 26192) }
    let(:genre) { Genre.new(igdb_id: 31) }
    let(:platform) { Platform.new(igdb_id: 48) }
    let(:release) { Release.new }

    before do
      allow(Game).to receive(:find_or_initialize_by).and_return(game)
      allow(game).to receive(:save!)
      allow(Genre).to receive(:find_or_create_by!).and_return(genre)
      allow(Platform).to receive(:find_or_create_by!).and_return(platform)
      allow(Release).to receive(:find_or_initialize_by).and_return(release)
    end

    context 'when the game is found on IGDB' do
      it 'imports the game with the given IGDB ID' do
        expect(game).to receive(:save!)
        expect(Genre).to receive(:find_or_create_by!).with(igdb_id: 31)
        expect(Platform).to receive(:find_or_create_by!).with(igdb_id: 48)

        imported_game = described_class.import(game.igdb_id)

        expect(imported_game).to have_attributes(name: 'The Last of Us Part II', genres: [genre], releases: [release])
        expect(release).to have_attributes(date: Date.new(2020, 6, 19), region: 'worldwide', game:, platform:)
      end
    end

    context 'when the game is not found on IGDB' do
      it 'raises a NotFound error' do
        expect { described_class.import(0) }.to raise_error(IGDB::Client::Errors::NotFound)
      end
    end
  end
end
