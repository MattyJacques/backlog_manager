# frozen_string_literal: true

require 'rails_helper'

RSpec.describe IGDB::Services::ImportPlatform do
  describe '.import' do
    let(:platform) { build(:platform) }
    let(:platform_family) { build(:platform_family) }

    before do
      allow(Platform).to receive(:find_or_initialize_by).and_return(platform)
      allow(PlatformFamily).to receive(:find_or_create_by!).and_return(platform_family)
    end

    context 'when the platform is found on IGDB' do
      context 'when there is a platform family' do
        let(:platform_params) do
          {
            name: 'PlayStation 4',
            abbreviation: 'PS4',
            slug: 'ps4--1',
            platform_family:
          }
        end
        let(:family_params) do
          {
            igdb_id: 1,
            name: 'PlayStation',
            slug: 'playstation'
          }
        end

        it 'imports platform data from IGDB API' do
          expect(platform).to receive(:update!).with(platform_params)
          expect(PlatformFamily).to receive(:find_or_create_by!).with(family_params)

          described_class.import(48)
        end
      end

      context 'when there is no platform family' do
        let(:platform_params) do
          {
            name: 'PC (Microsoft Windows)',
            abbreviation: 'PC',
            slug: 'win',
            platform_family: nil
          }
        end

        it 'imports platform data from IGDB API' do
          expect(platform).to receive(:update!).with(platform_params)
          expect(PlatformFamily).not_to receive(:find_or_create_by!)

          described_class.import(6)
        end
      end
    end

    context 'when no platform is found' do
      it 'raises an error' do
        expect { described_class.import(0) }.to raise_error(IGDB::Client::Errors::NotFound)
      end
    end
  end
end
