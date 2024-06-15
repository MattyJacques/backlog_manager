# frozen_string_literal: true

require 'rails_helper'

RSpec.describe IGDB::Client::Games do
  describe '.search' do
    context 'when arguments are valid' do
      it 'returns the search results of the name' do
        results = described_class.search('The Last of Us')

        expect(results.count).to be_positive
        results.each do |result|
          expect(result['name']).to include('The Last of Us')
        end
      end
    end

    context 'when arugments are invalid' do
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
end
