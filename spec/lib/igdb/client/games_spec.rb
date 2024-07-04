# frozen_string_literal: true

require 'rails_helper'

RSpec.describe IGDB::Client::Games do
  describe '.search' do
    context 'when parameters are valid' do
      it 'returns the search results of the name' do
        results = described_class.search('The Last of Us')

        expect(results.count).to be_positive
        results.each do |result|
          expect(result['name']).to include('The Last of Us')
        end
      end
    end

    context 'when parameters are invalid' do
      it 'handles blank game name' do
        expect(described_class).not_to receive(:post)

        expect { described_class.search('') }.to raise_error(RuntimeError, 'Search query should not be blank')
      end

      it 'handles game name of nil' do
        expect(described_class).not_to receive(:post)

        expect { described_class.search(nil) }.to raise_error(RuntimeError, 'Search query should not be blank')
      end
    end
  end

  describe '.get_by_id' do
    context 'when parameters are valid' do
      it 'returns the game with the given IGDB ID' do
        game = described_class.get_by_id(26192)

        expect(game['id']).to eq(26192)
        expect(game['name']).to eq('The Last of Us Part II')
      end

      context 'when no game is found' do
        it 'raises an error' do
          expect { described_class.get_by_id(0) }.to raise_error(IGDB::Client::Errors::NotFound)
        end
      end
    end

    context 'when parameters are invalid' do
      it 'handles blank IGDB ID' do
        expect(described_class).not_to receive(:post)

        expect { described_class.get_by_id('') }.to raise_error(RuntimeError, 'IGDB ID should not be blank')
      end

      it 'handles IGDB ID of nil' do
        expect(described_class).not_to receive(:post)

        expect { described_class.get_by_id(nil) }.to raise_error(RuntimeError, 'IGDB ID should not be blank')
      end
    end
  end
end
