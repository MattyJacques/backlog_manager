# frozen_string_literal: true

require 'rails_helper'

RSpec.describe PSN::Services::ImportPSNRelease do
  describe '.import', :vcr do
    let(:game_name) { 'LittleBigPlanet™' }
    let(:game) { instance_double(Game) }
    let(:trophy_list) { instance_double(TrophyList) }
    let(:ps3_platform) { instance_double(Platform, abbreviation: 'PS3') }
    let(:ps4_platform) { instance_double(Platform, abbreviation: 'PS4') }
    let(:psn_data) do
      {
        'trophyTitleName' => game_name,
        'trophyTitleDetail' => 'Play, Create, Share',
        'npCommunicationId' => 'NPWR00160_00',
        'npServiceName' => 'trophy',
        'trophyTitleIconUrl' => 'trophyicons.com',
        'trophyTitlePlatform' => 'PS3,PS4'
      }
    end

    before do
      allow(Game).to receive(:create).and_return(game)
      allow(PSN::Services::ImportTitleTrophyList).to receive(:import).and_return(trophy_list)
      allow(Platform).to receive(:find_by!).with(abbreviation: 'PS3').and_return(ps3_platform)
      allow(Platform).to receive(:find_by!).with(abbreviation: 'PS4').and_return(ps4_platform)
    end

    it 'imports the psn releases for title' do
      expect(Game).to receive(:create).with(name: game_name)
      expect(Release).to receive(:create).with(game:, platform: ps3_platform, trophy_list:)
      expect(Release).to receive(:create).with(game:, platform: ps4_platform, trophy_list:)

      described_class.import(psn_data)
    end
  end
end
