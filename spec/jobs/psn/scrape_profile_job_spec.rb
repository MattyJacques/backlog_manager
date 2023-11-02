# frozen_string_literal: true

require 'rails_helper'

RSpec.describe PSN::ScrapeProfileJob do
  describe '#perform' do
    let(:psn_id) { 'TestingGame00' }
    let(:game) { build(:game, :trophies) }
    let(:release) { game.releases.first }
    let(:trophy_list) { game.trophy_lists.first }
    let(:account_list) { build(:account_trophy_list, trophy_list:) }

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
    let(:psntl_ids) do
      [
        {
          id: 'grand-theft-auto-iv-ps3',
          date: 2.days.ago
        },
        {
          id: 'grand-theft-auto-v-ps4',
          date: DateTime.now
        }
      ]
    end

    before do
      allow(Spiders::PSNPProfileSpider).to receive(:process).with(psn_id).and_return(psnp_ids)
      allow(Spiders::PSNTLProfileSpider).to receive(:process).with(psn_id).and_return(psntl_ids)
    end

    it 'matches PSNP ids to trophy lists' do
      expect(Spiders::PSNPProfileSpider).to receive(:process).with(psn_id)
      expect(Spiders::PSNTLProfileSpider).to receive(:process).with(psn_id)
      expect(trophy_list).to receive(:update!).with(psnp_id: '12-grand-theft-auto-iv',
                                                    psntl_id: 'grand-theft-auto-iv-ps3')
      expect(trophy_list).to receive(:update!).with(psnp_id: '129-grand-theft-auto-v',
                                                    psntl_id: 'grand-theft-auto-v-ps4')
      expect(game).to receive(:update!).with(name: 'Grand Theft Auto IV')
      expect(game).to receive(:update!).with(name: 'Grand Theft Auto V')

      described_class.perform_now(psn_id, [trophy_list, trophy_list])
    end
  end
end
