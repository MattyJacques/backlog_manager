# frozen_string_literal: true

require 'rails_helper'

RSpec.describe PSN::ScrapePSNProfileJob do
  after { Capybara.reset_sessions! }

  describe '#perform' do
    let(:psn_id) {'TestingGame00' }
    let(:account_list) { instance_double(AccountTrophyList, trophy_list:) }
    let(:trophy_list) { instance_double(TrophyList, name: 'Testing12', releases: [release], psnp_id: nil) }
    let(:release) { instance_double(Release, game:) }
    let(:game) { instance_double(Game) }
    let(:psnp_ids) do
      [
        {
          psnp_id: '12-grand-theft-auto-iv',
          name: 'Grand Theft Auto IV'
        },
        {
          psnp_id: '129-grand-theft-auto-v',
          name: 'Grand Theft Auto V'
        }
      ]
    end

    before do
      allow(Spiders::PSNProfilesSpider).to receive(:process).with(psn_id).and_return(psnp_ids)
    end

    it 'matches PSNP ids to trophy lists' do
      expect(Spiders::PSNProfilesSpider).to receive(:process).with(psn_id)
      expect(trophy_list).to receive(:update!).with(psnp_id: '12-grand-theft-auto-iv')
      expect(trophy_list).to receive(:update!).with(psnp_id: '129-grand-theft-auto-v')
      expect(game).to receive(:update!).with(name: 'Grand Theft Auto IV')
      expect(game).to receive(:update!).with(name: 'Grand Theft Auto V')

      described_class.perform_now(psn_id, [trophy_list, trophy_list])
    end
  end
end
