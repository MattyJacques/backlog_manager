# frozen_string_literal: true

require 'rails_helper'

RSpec.describe IGDB::Client::Platforms do
  describe '.get_by_id' do
    context 'when parameters are valid' do
      let(:expected_params) do
        {
          'id' => 48,
          'name' => 'PlayStation 4',
          'abbreviation' => 'PS4',
          'slug' => 'ps4--1',
          'platform_family' => { 'id' => 1, 'name' => 'PlayStation', 'slug' => 'playstation' }
        }
      end

      it 'returns the genre with the given IGDB ID' do
        platform = described_class.get_by_id(48)

        expect(platform).to eq(expected_params)
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
