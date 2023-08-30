# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Spiders::PSNTLUnobtainableDatesSpider, spider_specs: true do
  describe '.process' do
    let(:psntl_id) { 'mag-ps3' }
    let(:trophy_list) { build(:trophy_list, psntl_id:) }

    before do
      allow(TrophyList).to receive(:find_by!).with(psntl_id:).and_return(trophy_list)
    end

    it 'crawls pages to get any server closure date for lists' do
      expect(TrophyList).to receive(:find_by!).with(psntl_id:)
      expect(trophy_list).to receive(:update!).with(server_shutdown_date: 'Jan 29, 2014'.to_date)

      described_class.process([psntl_id])
    end
  end
end
