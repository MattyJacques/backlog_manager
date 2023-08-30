# frozen_string_literal: true

require 'rails_helper'

RSpec.describe PSN::Services::ImportTitleTrophyList do
  describe '.import', :vcr do
    let(:trophy_list) { build(:trophy_list) }

    before do
      allow(TrophyList).to receive(:create).and_return(trophy_list)
    end

    it 'imports all trophies for the title' do
      expect(TrophyList).to receive(:create)
      expect(Trophy).to receive(:create).exactly(70).times

      described_class.import('LittleBigPlanet™', 'Play, Create, Share', 'NPWR00160_00', 'trophy', 'trophyicons.com')
    end
  end
end
